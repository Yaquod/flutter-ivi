import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// Polls the Cloudflare relay for the OAuth code on behalf of the IVI.
///
/// The phone never connects to the car — it talks only to the relay, which is
/// proper HTTPS on Cloudflare's cert. The IVI polls the relay every 2 s until
/// the code arrives or the session times out.
class SpotifyRelayClient {
  final String relayBaseUrl;
  final String sessionId;

  SpotifyRelayClient(this.relayBaseUrl) : sessionId = _newSessionId();

  static String _newSessionId() {
    final r = Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Polls `relay/poll?session=…` every 2 s until the code arrives.
  /// Throws [TimeoutException] after [timeout] (default 5 min).
  Future<String> pollForCode({
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final deadline = DateTime.now().add(timeout);
    final pollUri = Uri.parse('$relayBaseUrl/poll')
        .replace(queryParameters: {'session': sessionId});

    while (DateTime.now().isBefore(deadline)) {
      try {
        final response =
            await http.get(pollUri).timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          if (body['code'] is String) return body['code'] as String;
        }
      } catch (_) {
        // Network hiccup — retry on next tick
      }
      await Future.delayed(const Duration(seconds: 2));
    }
    throw TimeoutException('Spotify login timed out', timeout);
  }
}
