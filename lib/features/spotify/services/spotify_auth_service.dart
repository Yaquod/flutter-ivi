import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'http_client_factory.dart';
import 'simple_token_storage.dart';

class SpotifyAuthService {
  static const defaultRedirectUri = 'http://127.0.0.1:8080/callback';
  static const _scopes = [
    'user-read-playback-state',
    'user-modify-playback-state',
    'user-read-currently-playing',
    'user-read-recently-played',
    'playlist-read-private',
    'playlist-read-collaborative',
    'streaming',
  ];

  static const _keyAccessToken = 'spotify_access_token';
  static const _keyRefreshToken = 'spotify_refresh_token';
  static const _keyExpiryMs = 'spotify_token_expiry_ms';

  final SimpleTokenStorage _storage;
  final http.Client _http;

  SpotifyAuthService({SimpleTokenStorage? storage, http.Client? httpClient})
      : _storage = storage ?? SimpleTokenStorage(),
        _http = httpClient ?? createSpotifyHttpClient();

  String get _clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';

  String generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(96, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _codeChallenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Uri buildAuthUri(String codeVerifier,
          {String redirectUri = defaultRedirectUri}) =>
      Uri.https(
        'accounts.spotify.com',
        '/authorize',
        {
          'client_id': _clientId,
          'response_type': 'code',
          'redirect_uri': redirectUri,
          'code_challenge_method': 'S256',
          'code_challenge': _codeChallenge(codeVerifier),
          'scope': _scopes.join(' '),
        },
      );

  /// Builds the URL that goes into the QR code when using the relay flow.
  /// The relay's /auth endpoint takes these params, adds its own redirect_uri,
  /// and sends the phone to Spotify.
  String buildRelayQrUrl(
      String codeVerifier, String sessionId, String relayBaseUrl) =>
      Uri.parse('$relayBaseUrl/auth').replace(queryParameters: {
        'session': sessionId,
        'client_id': _clientId,
        'challenge': _codeChallenge(codeVerifier),
        'scope': _scopes.join(' '),
      }).toString();

  Future<void> exchangeCode(String code, String codeVerifier,
      {String redirectUri = defaultRedirectUri}) async {
    final response = await _http.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'client_id': _clientId,
        'code_verifier': codeVerifier,
      },
    );
    if (response.statusCode != 200) {
      throw SpotifyAuthException('Token exchange failed: ${response.body}');
    }
    await _saveTokens(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    if (refreshToken == null) return null;

    final response = await _http.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': _clientId,
      },
    );
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    await _saveTokens(json);
    return json['access_token'] as String;
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  Future<bool> isTokenValid() async {
    final expiry = await _storage.read(key: _keyExpiryMs);
    if (expiry == null) return false;
    final expiryMs = int.tryParse(expiry) ?? 0;
    return DateTime.now().millisecondsSinceEpoch < expiryMs - 60000;
  }

  Future<void> clearTokens() => _storage.deleteAll();

  Future<void> _saveTokens(Map<String, dynamic> json) async {
    final expiresIn = json['expires_in'] as int;
    final expiryMs = DateTime.now().millisecondsSinceEpoch + expiresIn * 1000;
    await _storage.writeAll({
      _keyAccessToken: json['access_token'] as String,
      _keyExpiryMs: expiryMs.toString(),
      if (json['refresh_token'] != null)
        _keyRefreshToken: json['refresh_token'] as String,
    });
  }
}

class SpotifyAuthException implements Exception {
  final String message;
  SpotifyAuthException(this.message);
  @override
  String toString() => 'SpotifyAuthException: $message';
}
