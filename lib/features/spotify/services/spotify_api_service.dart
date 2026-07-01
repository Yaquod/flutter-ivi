import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spotify_playback_state.dart';
import '../models/spotify_device.dart';
import '../models/spotify_track.dart';
import '../models/spotify_playlist.dart';
import 'http_client_factory.dart';

class SpotifyApiService {
  static const _base = 'https://api.spotify.com/v1';

  final Future<String?> Function() getToken;
  final http.Client _http;

  SpotifyApiService({required this.getToken, http.Client? client})
      : _http = client ?? createSpotifyHttpClient();

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    if (token == null) throw SpotifyApiException(401, 'No access token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<SpotifyPlaybackState?> getPlaybackState() async {
    final r = await _http.get(
      Uri.parse('$_base/me/player?additional_types=track'),
      headers: await _headers(),
    );
    if (r.statusCode == 204) return null;
    _assertOk(r);
    return SpotifyPlaybackState.fromJson(
        jsonDecode(r.body) as Map<String, dynamic>);
  }

  Future<List<SpotifyDevice>> getDevices() async {
    final r = await _http.get(
      Uri.parse('$_base/me/player/devices'),
      headers: await _headers(),
    );
    _assertOk(r);
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    return (data['devices'] as List)
        .map((d) => SpotifyDevice.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  Future<void> play({String? deviceId}) async {
    final r = await _http.put(
      Uri.parse('$_base/me/player/play${_deviceQuery(deviceId)}'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> pause({String? deviceId}) async {
    final r = await _http.put(
      Uri.parse('$_base/me/player/pause${_deviceQuery(deviceId)}'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> skipToNext({String? deviceId}) async {
    final r = await _http.post(
      Uri.parse('$_base/me/player/next${_deviceQuery(deviceId)}'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> skipToPrevious({String? deviceId}) async {
    final r = await _http.post(
      Uri.parse('$_base/me/player/previous${_deviceQuery(deviceId)}'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> seekToPosition(int positionMs, {String? deviceId}) async {
    final q =
        'position_ms=$positionMs${deviceId != null ? '&device_id=$deviceId' : ''}';
    final r = await _http.put(
      Uri.parse('$_base/me/player/seek?$q'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> transferPlayback(String deviceId, {bool play = true}) async {
    final r = await _http.put(
      Uri.parse('$_base/me/player'),
      headers: await _headers(),
      body: jsonEncode({'device_ids': [deviceId], 'play': play}),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> setShuffle({required bool state, String? deviceId}) async {
    final q = 'state=$state${_deviceQuery(deviceId, prefix: '&')}';
    final r = await _http.put(
      Uri.parse('$_base/me/player/shuffle?$q'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> setRepeat({required String state, String? deviceId}) async {
    final q = 'state=$state${_deviceQuery(deviceId, prefix: '&')}';
    final r = await _http.put(
      Uri.parse('$_base/me/player/repeat?$q'),
      headers: await _headers(),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<String> getCurrentUserId() async {
    final r = await _http.get(
      Uri.parse('$_base/me'),
      headers: await _headers(),
    );
    _assertOk(r);
    return (jsonDecode(r.body) as Map<String, dynamic>)['id'] as String;
  }

  Future<List<SpotifyTrack>> getRecentlyPlayed({int limit = 6}) async {
    final r = await _http.get(
      Uri.parse('$_base/me/player/recently-played?limit=$limit'),
      headers: await _headers(),
    );
    _assertOk(r);
    final items = (jsonDecode(r.body) as Map)['items'] as List;
    return items
        .map((e) => SpotifyTrack.fromJson(e['track'] as Map<String, dynamic>))
        .toList();
  }

  Future<List<SpotifyPlaylist>> getUserPlaylists({int limit = 8}) async {
    final r = await _http.get(
      Uri.parse('$_base/me/playlists?limit=$limit'),
      headers: await _headers(),
    );
    _assertOk(r);
    final items = (jsonDecode(r.body) as Map)['items'] as List;
    return items
        .map((e) => SpotifyPlaylist.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> playTrackUri(String trackUri, {String? deviceId}) async {
    final r = await _http.put(
      Uri.parse('$_base/me/player/play${_deviceQuery(deviceId)}'),
      headers: await _headers(),
      body: jsonEncode({'uris': [trackUri]}),
    );
    _assertOk(r, allowEmpty: true);
  }

  Future<void> playContextUri(String contextUri, {String? deviceId}) async {
    final r = await _http.put(
      Uri.parse('$_base/me/player/play${_deviceQuery(deviceId)}'),
      headers: await _headers(),
      body: jsonEncode({'context_uri': contextUri}),
    );
    _assertOk(r, allowEmpty: true);
  }

  String _deviceQuery(String? id, {String prefix = '?'}) =>
      id != null ? '${prefix}device_id=$id' : '';

  void _assertOk(http.Response r, {bool allowEmpty = false}) {
    if (r.statusCode == 204 && allowEmpty) return;
    if (r.statusCode >= 200 && r.statusCode < 300) return;
    throw SpotifyApiException(r.statusCode, r.body);
  }
}

class SpotifyApiException implements Exception {
  final int statusCode;
  final String body;
  SpotifyApiException(this.statusCode, this.body);
  @override
  String toString() => 'SpotifyApiException($statusCode): $body';
}
