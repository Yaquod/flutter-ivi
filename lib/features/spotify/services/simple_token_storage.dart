import 'dart:io';
import 'dart:convert';

/// File-based token storage that works on any platform without native plugins.
/// Tokens are stored as plain JSON at ~/.local/share/flutter_ivi/spotify_tokens.json.
/// This is acceptable for an embedded IVI system where the device is physically secured.
class SimpleTokenStorage {
  static const _dir = '.local/share/flutter_ivi';
  static const _fileName = 'spotify_tokens.json';

  File get _file {
    final home = Platform.environment['HOME'] ?? '/tmp';
    return File('$home/$_dir/$_fileName');
  }

  Future<void> write({required String key, required String value}) async {
    final data = await _readAll();
    data[key] = value;
    await _writeAll(data);
  }

  /// Writes multiple key-value pairs in a single file operation so they
  /// cannot overwrite each other (unlike concurrent individual writes).
  Future<void> writeAll(Map<String, String> pairs) async {
    final data = await _readAll();
    data.addAll(pairs);
    await _writeAll(data);
  }

  Future<String?> read({required String key}) async {
    final data = await _readAll();
    return data[key] as String?;
  }

  Future<void> deleteAll() async {
    try {
      final f = _file;
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  Future<Map<String, dynamic>> _readAll() async {
    try {
      final f = _file;
      if (!await f.exists()) return {};
      return jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeAll(Map<String, dynamic> data) async {
    final f = _file;
    await f.parent.create(recursive: true);
    await f.writeAsString(jsonEncode(data));
  }
}
