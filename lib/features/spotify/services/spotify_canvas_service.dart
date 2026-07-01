import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CanvasResult {
  final String url;
  final bool isVideo;
  const CanvasResult({required this.url, required this.isVideo});
}

/// Fetches Spotify Canvas URLs via the spclient protobuf endpoint.
///
/// The Canvas endpoint requires a librespot/AP session token — PKCE tokens
/// are rejected with 403 (RBAC). We obtain the correct token by spawning
/// a small Python script that authenticates with spotifyd's stored
/// credentials (~/.cache/spotifyd/oauth/credentials.json).
class SpotifyCanvasService {
  static const _endpoint =
      'https://spclient.wg.spotify.com/canvaz-cache/v0/canvases';

  static final _scriptPath = () {
    final home = Platform.environment['HOME'] ?? '/home/wafdy';
    return '$home/gp/flutter_ivi/scripts/spotify_librespot_token.py';
  }();

  // Only cache confirmed results (200 responses); never cache failures so
  // the next track poll retries automatically.
  final Map<String, CanvasResult?> _cache = {};
  final _http = http.Client();

  // Cached librespot token (valid ~1 h; refreshed after 50 min)
  String? _librespotToken;
  DateTime? _tokenExpiry;

  // Serialise concurrent token fetches — a second caller waits for the
  // in-flight Python process instead of spawning its own.
  Future<String?>? _tokenFetch;

  /// Pre-warm the librespot token 5 s after spotifyd starts so the
  /// oauth/credentials.json is definitely written before we use it.
  void prewarm() => _getLibrespotToken();

  Future<String?> _getLibrespotToken() {
    if (_librespotToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return Future.value(_librespotToken);
    }
    // Reuse in-flight fetch to avoid two Python processes hitting the AP
    // simultaneously (causes "unpack requires a buffer of 4 bytes" error).
    return _tokenFetch ??=
        _spawnTokenScript().whenComplete(() => _tokenFetch = null);
  }

  Future<String?> _spawnTokenScript() async {
    final script = _scriptPath;
    if (!File(script).existsSync()) {
      debugPrint('[Canvas] token script not found: $script');
      return null;
    }
    try {
      final result = await Process.run('python3', [script],
          stdoutEncoding: const Utf8Codec(),
          stderrEncoding: const Utf8Codec());
      if (result.exitCode == 0) {
        final token = (result.stdout as String).trim();
        if (token.isNotEmpty) {
          _librespotToken = token;
          _tokenExpiry = DateTime.now().add(const Duration(minutes: 50));
          debugPrint('[Canvas] librespot token refreshed');
          return token;
        }
      }
      debugPrint('[Canvas] token script failed: ${result.stderr}');
    } catch (e) {
      debugPrint('[Canvas] could not spawn token script: $e');
    }
    return null;
  }

  Future<CanvasResult?> getCanvasUrl(
    String trackUri,
    Future<String?> Function() getPkceToken,
  ) async {
    if (_cache.containsKey(trackUri)) return _cache[trackUri];

    // Prefer the librespot AP token; PKCE tokens are 403 on Canvas.
    final token = await _getLibrespotToken() ?? await getPkceToken();
    if (token == null) return null;

    try {
      final response = await _http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-protobuf',
          'Accept': 'application/x-protobuf',
          'app-platform': 'iOS',
          'Spotify-App-Version': '8.5.49.864',
          'User-Agent': 'Spotify/8.5.49 iOS/14.3 (iPhone12,1)',
          'Accept-Language': 'en',
        },
        body: _encodeRequest(trackUri),
      );

      if (response.statusCode == 200) {
        final result = _decodeResponse(response.bodyBytes);
        debugPrint(
            '[Canvas] ${result != null ? "found ${result.isVideo ? "video" : "image"}: ${result.url}" : "empty"} for $trackUri');
        _cache[trackUri] = result; // only cache confirmed results
        return result;
      }

      if (response.statusCode == 401) {
        _librespotToken = null;
        _tokenExpiry = null;
        debugPrint('[Canvas] 401 — token expired, cleared for next poll');
      } else {
        debugPrint('[Canvas] no canvas (${response.statusCode}) for $trackUri');
      }
      // Do NOT cache failures — next poll will retry with fresh token.
    } catch (e) {
      debugPrint('[Canvas] error: $e');
    }
    return null;
  }

  void dispose() => _http.close();

  // ── Protobuf encoding ────────────────────────────────────────────────────────

  static List<int> _encodeRequest(String trackUri) {
    final uriBytes = utf8.encode(trackUri);
    final inner = <int>[0x0a, ..._varint(uriBytes.length), ...uriBytes];
    return [0x0a, ..._varint(inner.length), ...inner];
  }

  static CanvasResult? _decodeResponse(List<int> bytes) {
    int i = 0;
    while (i < bytes.length) {
      final (tag, tagLen) = _varintAt(bytes, i);
      i += tagLen;
      final wireType = tag & 0x7;
      if (wireType == 2) {
        final (len, lenLen) = _varintAt(bytes, i);
        i += lenLen;
        final data = bytes.sublist(i, i + len);
        i += len;
        if (tag >> 3 == 1) {
          final result = _decodeCanvaz(data);
          if (result != null) return result;
        }
      } else {
        i = _skipField(bytes, i, wireType);
      }
    }
    return null;
  }

  static CanvasResult? _decodeCanvaz(List<int> bytes) {
    String? url, type;
    int i = 0;
    while (i < bytes.length) {
      final (tag, tagLen) = _varintAt(bytes, i);
      i += tagLen;
      final fieldNum = tag >> 3;
      final wireType = tag & 0x7;
      if (wireType == 2) {
        final (len, lenLen) = _varintAt(bytes, i);
        i += lenLen;
        final data = bytes.sublist(i, i + len);
        i += len;
        if (fieldNum == 2) {
          url = utf8.decode(data, allowMalformed: true);
        } else if (fieldNum == 4) {
          type = utf8.decode(data, allowMalformed: true);
        }
      } else {
        i = _skipField(bytes, i, wireType);
      }
    }
    if (url == null || url.isEmpty) return null;
    // type field may be absent; URL itself confirms video via .mp4 extension
    final isVideo =
        type == 'VIDEO' || url.contains('.mp4') || url.contains('/video/');
    return CanvasResult(url: url, isVideo: isVideo);
  }

  // ── Protobuf helpers ─────────────────────────────────────────────────────────

  static List<int> _varint(int v) {
    if (v < 0x80) return [v];
    final r = <int>[];
    while (v >= 0x80) {
      r.add((v & 0x7f) | 0x80);
      v >>= 7;
    }
    r.add(v);
    return r;
  }

  static (int, int) _varintAt(List<int> bytes, int offset) {
    int result = 0, shift = 0, i = offset;
    while (i < bytes.length) {
      final b = bytes[i++];
      result |= (b & 0x7f) << shift;
      shift += 7;
      if (b & 0x80 == 0) break;
    }
    return (result, i - offset);
  }

  static int _skipField(List<int> bytes, int i, int wireType) {
    switch (wireType) {
      case 0:
        while (i < bytes.length && bytes[i] & 0x80 != 0) {
          i++;
        }
        return i + 1;
      case 1:
        return i + 8;
      case 2:
        final (len, lenLen) = _varintAt(bytes, i);
        return i + lenLen + len;
      case 5:
        return i + 4;
      default:
        return bytes.length;
    }
  }
}
