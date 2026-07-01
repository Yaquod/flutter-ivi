import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Manages spotifyd so the IVI appears as a Spotify Connect device.
///
/// Flow on every login:
///   1. writeCredentials(accessToken, userId) — writes librespot credential
///      cache so spotifyd can authenticate without a browser.
///   2. start() — launches spotifyd; it reads the cache and authenticates.
///   3. On successful auth, spotifyd overwrites the cache with long-lived
///      stored credentials, so future launches need no token at all.
class SpotifyConnectService {
  static const _deviceName = 'Toyota IVI';
  static const _maxRestarts = 3;

  Process? _process;
  bool _stopping = false;
  int _restartCount = 0;
  bool authFailed = false;

  String get _backend => dotenv.env['SPOTIFYD_BACKEND'] ?? 'alsa';

  // ── Credential bootstrap ──────────────────────────────────────────────────

  /// Writes the librespot credential file in spotifyd's cache so the daemon
  /// can authenticate using our OAuth access token — no browser required.
  ///
  /// Format confirmed from librespot 0.5.x source (crates/core/src/cache.rs):
  ///   `{ "username": "id", "credentials": "base64(token_bytes)", "type": 4 }`
  ///   type 4 = AUTHENTICATION_SPOTIFY_TOKEN
  Future<void> writeCredentials(String accessToken, String userId) async {
    try {
      final home = Platform.environment['HOME'] ?? '';
      final cacheDir = Directory('$home/.cache/spotifyd');
      await cacheDir.create(recursive: true);

      final credFile = File('${cacheDir.path}/credentials.json');
      await credFile.writeAsString(jsonEncode({
        'username': userId,
        'credentials': base64.encode(utf8.encode(accessToken)),
        'type': 4,
      }));
      debugPrint('[spotifyd] credentials written for $userId');
    } catch (e) {
      debugPrint('[spotifyd] could not write credentials: $e');
    }
  }

  // ── Process management ────────────────────────────────────────────────────

  Future<void> start(String accessToken) async {
    _stopping = false;
    _restartCount = 0;
    authFailed = false;
    await _launch();
  }

  Future<void> _launch() async {
    await _killExisting();
    try {
      // Inherit full environment and pin PulseAudio socket path so spotifyd
      // can reach it when Flutter spawns it outside a full login session.
      final env = Map<String, String>.from(Platform.environment);
      final xdg = env['XDG_RUNTIME_DIR'] ?? '/run/user/1000';
      env['XDG_RUNTIME_DIR'] = xdg;
      if (_backend == 'pulseaudio') {
        env['PULSE_SERVER'] = 'unix:$xdg/pulse/native';
      }

      _process = await Process.start(
        'spotifyd',
        [
          '--no-daemon',
          '--device-name', _deviceName,
          '--backend', _backend,
          '--bitrate', '320',
          '--volume-controller', 'soft-volume',
          '--device-type', 'automobile',
        ],
        mode: ProcessStartMode.normal,
        environment: env,
      );

      debugPrint('[spotifyd] started — pid ${_process!.pid}, '
          'device: $_deviceName, backend: $_backend');

      _process!.stdout.transform(const SystemEncoding().decoder).listen(_onLine);
      _process!.stderr.transform(const SystemEncoding().decoder).listen(_onLine);
      _process!.exitCode.then(_onExit);
    } catch (e) {
      debugPrint('[spotifyd] could not start: $e');
    }
  }

  void _onLine(String raw) {
    for (final line in raw.split('\n')) {
      final t = line.trim();
      if (t.isEmpty) continue;
      debugPrint('[spotifyd] $t');
      if (t.contains('Authenticated as')) authFailed = false;
      if (_isAuthError(t)) {
        authFailed = true;
        debugPrint('[spotifyd] ✗ auth failed — credentials may be stale');
      }
    }
  }

  bool _isAuthError(String line) {
    final l = line.toLowerCase();
    return l.contains('bad credentials') ||
        l.contains('failed to authenticate') ||
        l.contains('invalid credentials') ||
        l.contains('no credentials') ||
        l.contains('authentication failed');
  }

  void _onExit(int code) {
    if (_stopping) return;
    debugPrint('[spotifyd] exited with code $code');
    if (_restartCount < _maxRestarts) {
      _restartCount++;
      debugPrint('[spotifyd] restarting ($_restartCount/$_maxRestarts)…');
      Future.delayed(const Duration(seconds: 2), _launch);
    } else {
      debugPrint('[spotifyd] gave up after $_maxRestarts restarts');
    }
  }

  Future<void> stop() async {
    _stopping = true;
    _restartCount = _maxRestarts;
    _process?.kill(ProcessSignal.sigterm);
    _process = null;
    await _killExisting();
  }

  Future<void> _killExisting() async {
    try {
      await Process.run('pkill', ['-f', 'spotifyd']);
    } catch (_) {}
  }
}
