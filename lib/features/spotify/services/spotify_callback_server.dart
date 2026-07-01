import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// One-shot HTTPS callback server for Spotify OAuth.
///
/// Uses a self-signed TLS certificate (generated once via openssl and cached in
/// /tmp) so Spotify accepts the redirect URI (Spotify requires HTTPS for any
/// non-localhost redirect). The phone's browser will show a "connection not
/// private" warning — the user taps Advanced → Proceed to complete login.
class SpotifyCallbackServer {
  static const int kPort = 8443;

  HttpServer? _server;
  Completer<String>? _completer;

  // In-memory cert cache. Regenerated when the local IP changes.
  static String? _certIp;
  static Uint8List? _certBytes;
  static Uint8List? _keyBytes;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns the best IPv4 address for reaching this device from a phone.
  /// Prefers physical WiFi/Ethernet (wlan*, eth*, enp*, wlp*, ens*) and skips
  /// virtual bridges (192.168.64.x, docker, virbr, br-, veth, etc.).
  static Future<String> getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );

      // Log all candidates for debugging
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) {
            // ignore: avoid_print
            print('[SpotifyCallbackServer] interface ${iface.name}: ${addr.address}');
          }
        }
      }

      const _virtualPrefixes = [
        'virbr', 'docker', 'br-', 'veth', 'tun', 'tap',
        'utun', 'vmnet', 'vboxnet', 'lxc', 'lxdbr',
      ];
      // Virtual subnets commonly assigned to VM bridges
      const _virtualSubnets = ['192.168.64.', '172.17.', '172.18.', '10.0.2.'];

      String? bestPhysical;
      String? anyNonVirtual;
      String? anyNonLoopback;

      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        final isVirtualName =
            _virtualPrefixes.any((p) => name.startsWith(p));

        for (final addr in iface.addresses) {
          if (addr.isLoopback) continue;
          final ip = addr.address;
          final isVirtualSubnet =
              _virtualSubnets.any((s) => ip.startsWith(s));

          anyNonLoopback ??= ip;

          if (!isVirtualName && !isVirtualSubnet) {
            anyNonVirtual ??= ip;
            // Prefer wlan/eth/en/wlp/enp/ens interfaces
            final isPhysical = name.startsWith('wlan') ||
                name.startsWith('wifi') ||
                name.startsWith('eth') ||
                name.startsWith('en') ||
                name.startsWith('wlp') ||
                name.startsWith('wlo') ||
                name.startsWith('enp') ||
                name.startsWith('ens');
            if (isPhysical) bestPhysical ??= ip;
          }
        }
      }

      final chosen = bestPhysical ?? anyNonVirtual ?? anyNonLoopback;
      print('[SpotifyCallbackServer] chosen IP: $chosen');
      return chosen ?? '127.0.0.1';
    } catch (_) {}
    return '127.0.0.1';
  }

  /// Generates (and caches) a self-signed cert for [ip] using openssl.
  /// Safe to call repeatedly — regenerates only when the IP changes.
  static Future<void> ensureCert(String ip) async {
    if (_certIp == ip && _certBytes != null) return;

    const certPath = '/tmp/ivi_spotify_cert.pem';
    const keyPath = '/tmp/ivi_spotify_key.pem';

    // Use EC P-256 — key generation is ~10× faster than RSA 2048.
    final result = await Process.run('openssl', [
      'req', '-x509',
      '-newkey', 'ec',
      '-pkeyopt', 'ec_paramgen_curve:P-256',
      '-keyout', keyPath,
      '-out', certPath,
      '-days', '3650',
      '-nodes',
      '-subj', '/CN=ivi-waymo',
      '-addext', 'subjectAltName=IP:$ip,IP:127.0.0.1',
    ]);

    if (result.exitCode != 0) {
      // Fallback to RSA 2048 if EC syntax not supported by older openssl
      final fallback = await Process.run('openssl', [
        'req', '-x509',
        '-newkey', 'rsa:2048',
        '-keyout', keyPath,
        '-out', certPath,
        '-days', '3650',
        '-nodes',
        '-subj', '/CN=ivi-waymo/subjectAltName=IP:$ip',
      ]);
      if (fallback.exitCode != 0) {
        throw Exception('openssl cert generation failed: ${fallback.stderr}');
      }
    }

    _certIp = ip;
    _certBytes = await File(certPath).readAsBytes();
    _keyBytes = await File(keyPath).readAsBytes();
  }

  /// Starts the HTTPS server and returns a Future that resolves with the OAuth
  /// code when the phone completes the Spotify login redirect.
  Future<String> waitForCode() {
    _completer = Completer<String>();
    _startServer();
    return _completer!.future;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _startServer() async {
    try {
      if (_certBytes == null || _keyBytes == null) {
        throw Exception('Call ensureCert() before waitForCode()');
      }
      final ctx = SecurityContext()
        ..useCertificateChainBytes(_certBytes!)
        ..usePrivateKeyBytes(_keyBytes!);

      _server = await HttpServer.bindSecure(
        InternetAddress.anyIPv4,
        kPort,
        ctx,
        shared: true,
      );

      await for (final req in _server!) {
        if (req.uri.path != '/callback') {
          req.response
            ..statusCode = 404
            ..close();
          continue;
        }
        final code = req.uri.queryParameters['code'];
        final error = req.uri.queryParameters['error'];
        req.response
          ..statusCode = 200
          ..headers.contentType = ContentType.html
          ..write(code != null ? _kSuccessHtml : _kErrorHtml)
          ..close();
        if (_completer != null && !_completer!.isCompleted) {
          if (code != null) {
            _completer!.complete(code);
          } else {
            _completer!
                .completeError(Exception('Spotify login denied: $error'));
          }
        }
        await stop();
        break;
      }
    } catch (e) {
      if (_completer != null && !_completer!.isCompleted) {
        _completer!.completeError(e);
      }
    }
  }

  // ── Success / error pages sent to the phone browser ───────────────────────

  static const _kSuccessHtml = '''<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Spotify Connected</title>
<meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="background:#191414;color:#fff;font-family:-apple-system,Helvetica,sans-serif;
     display:flex;align-items:center;justify-content:center;height:100vh;margin:0;text-align:center">
  <div>
    <div style="width:80px;height:80px;background:#1DB954;border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                margin:0 auto 24px;font-size:40px">✓</div>
    <h2 style="margin:0 0 12px;font-size:26px">Connected to Spotify!</h2>
    <p style="color:#b3b3b3;margin:0;font-size:16px">
      Return to the vehicle screen to enjoy your music.
    </p>
  </div>
  <script>setTimeout(()=>window.close(),2500)</script>
</body>
</html>''';

  static const _kErrorHtml = '''<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Login Failed</title></head>
<body style="background:#191414;color:#fff;font-family:sans-serif;
     display:flex;align-items:center;justify-content:center;height:100vh;margin:0;text-align:center">
  <div>
    <div style="font-size:64px;margin-bottom:16px">✗</div>
    <h2>Login failed</h2>
    <p style="color:#b3b3b3">Please try again from the vehicle screen.</p>
  </div>
</body>
</html>''';
}
