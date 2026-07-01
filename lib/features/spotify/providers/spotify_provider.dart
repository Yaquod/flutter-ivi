import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/spotify_playback_state.dart';
import '../models/spotify_device.dart';
import '../models/spotify_track.dart';
import '../models/spotify_playlist.dart';
import '../services/spotify_auth_service.dart';
import '../services/spotify_api_service.dart';
import '../services/spotify_relay_client.dart';
import '../services/spotify_connect_service.dart';
import '../services/album_palette_service.dart';
import '../services/spotify_canvas_service.dart';

enum SpotifyStatus { unauthenticated, authenticating, authenticated, error }

class SpotifyProvider extends ChangeNotifier {
  final SpotifyAuthService _auth;
  late final SpotifyApiService _api;
  final _connect = SpotifyConnectService();
  final _paletteService = AlbumPaletteService();
  final _canvasService = SpotifyCanvasService();

  SpotifyStatus _status = SpotifyStatus.unauthenticated;
  SpotifyPlaybackState? _playback;
  List<SpotifyDevice> _devices = [];
  List<SpotifyTrack> _recentTracks = [];
  List<SpotifyPlaylist> _userPlaylists = [];
  String? _errorMessage;
  bool _isBusy = false;
  bool _recommendationsLoading = false;
  String? _pendingVerifier;
  String? _pendingRedirectUri;
  int _authFailureCount = 0;
  AlbumPalette _palette = AlbumPalette.fallback;
  String? _lastArtUrl;
  CanvasResult? _canvas;

  Timer? _playTimer;
  Timer? _pauseTimer;

  SpotifyStatus get status => _status;
  bool get isAuthenticated => _status == SpotifyStatus.authenticated;
  SpotifyPlaybackState? get playback => _playback;
  List<SpotifyDevice> get devices => _devices;
  List<SpotifyTrack> get recentTracks => _recentTracks;
  List<SpotifyPlaylist> get userPlaylists => _userPlaylists;
  bool get recommendationsLoading => _recommendationsLoading;
  AlbumPalette get palette => _palette;
  String? get canvasUrl => _canvas?.url;
  bool get canvasIsVideo => _canvas?.isVideo ?? false;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _playback?.isPlaying ?? false;
  SpotifyTrack? get currentTrack => _playback?.track;

  SpotifyProvider({SpotifyAuthService? authService})
      : _auth = authService ?? SpotifyAuthService() {
    _api = SpotifyApiService(getToken: _getValidToken);
    _initFromStorage();
  }

  Future<void> _initFromStorage() async {
    if (await _auth.isTokenValid()) {
      _status = SpotifyStatus.authenticated;
      notifyListeners();
      _startPolling();
      _fetchRecommendations();
      _launchConnect();
    }
  }

  /// Returns the Spotify auth URL. [redirectUri] must match the server listening
  /// for the callback (car's local IP for QR mode, 127.0.0.1 for WebView mode).
  String beginAuth({String? redirectUri}) {
    _pendingVerifier = _auth.generateCodeVerifier();
    _pendingRedirectUri =
        redirectUri ?? SpotifyAuthService.defaultRedirectUri;
    _status = SpotifyStatus.authenticating;
    notifyListeners();
    return _auth
        .buildAuthUri(_pendingVerifier!, redirectUri: _pendingRedirectUri!)
        .toString();
  }

  /// Relay-based QR login. Returns the QR URL to display and a Future that
  /// resolves with the OAuth code once the passenger completes login on their
  /// phone. The phone talks only to the relay — no IP or cert issues.
  ({String qrUrl, Future<String> codeFuture}) beginAuthViaRelay(
      SpotifyRelayClient client) {
    _pendingVerifier = _auth.generateCodeVerifier();
    _pendingRedirectUri = '${client.relayBaseUrl}/callback';
    _status = SpotifyStatus.authenticating;
    notifyListeners();

    final qrUrl = _auth.buildRelayQrUrl(
      _pendingVerifier!,
      client.sessionId,
      client.relayBaseUrl,
    );
    return (qrUrl: qrUrl, codeFuture: client.pollForCode());
  }

  /// Call when the callback server (HTTP or WebView) captures the ?code=.
  Future<void> completeAuth(String code) async {
    try {
      await _auth.exchangeCode(code, _pendingVerifier!,
          redirectUri: _pendingRedirectUri ?? SpotifyAuthService.defaultRedirectUri);
      _pendingVerifier = null;
      _pendingRedirectUri = null;
      _authFailureCount = 0;
      _status = SpotifyStatus.authenticated;
      notifyListeners();
      _startPolling();
      _fetchRecommendations();
      _launchConnect();       // start spotifyd so IVI speakers produce audio
      _autoTransferToIVI();   // wait for device + transfer + play (background)
    } catch (e) {
      _status = SpotifyStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> _launchConnect() async {
    final token = await _auth.getAccessToken();
    if (token == null) return;
    // Write librespot credential cache so spotifyd authenticates without a browser
    try {
      final userId = await _api.getCurrentUserId();
      await _connect.writeCredentials(token, userId);
    } catch (e) {
      debugPrint('[Spotify] could not write spotifyd credentials: $e');
    }
    await _connect.start(token);
    // Pre-warm librespot token after spotifyd has written oauth/credentials.json.
    // 5 s gives spotifyd enough time to authenticate and write the credentials.
    Future.delayed(const Duration(seconds: 5), _canvasService.prewarm);
  }

  Future<void> logout() async {
    _stopPolling();
    await _connect.stop();
    await _auth.clearTokens();
    _status = SpotifyStatus.unauthenticated;
    _playback = null;
    _devices = [];
    _recentTracks = [];
    _userPlaylists = [];
    _palette = AlbumPalette.fallback;
    _lastArtUrl = null;
    _canvas = null;
    notifyListeners();
  }

  void _startPolling() {
    _stopPolling();
    _playTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _pollWhenPlaying(),
    );
    _pauseTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollWhenPaused(),
    );
  }

  void _stopPolling() {
    _playTimer?.cancel();
    _pauseTimer?.cancel();
  }

  Future<void> _pollWhenPlaying() async {
    if (!isPlaying || _isBusy || !isAuthenticated) return;
    await _fetchPlayback();
  }

  Future<void> _pollWhenPaused() async {
    if (isPlaying || _isBusy || !isAuthenticated) return;
    await _fetchPlayback();
  }

  Future<void> _fetchPlayback() async {
    _isBusy = true;
    try {
      _playback = await _api.getPlaybackState();
      _authFailureCount = 0;
      final artUrl = _playback?.track?.albumArtUrl;
      final uri = _playback?.track?.uri;
      if (artUrl != _lastArtUrl) {
        _lastArtUrl = artUrl;
        _paletteService.extract(artUrl).then((p) {
          _palette = p;
          notifyListeners();
        });
        if (uri != null) {
          _canvas = null;
          _canvasService.getCanvasUrl(uri, _getValidToken).then((result) {
            _canvas = result;
            notifyListeners();
          });
        } else {
          _canvas = null;
        }
      } else if (_canvas == null && uri != null) {
        // Retry canvas if the first attempt failed (e.g. token race at startup).
        _canvasService.getCanvasUrl(uri, _getValidToken).then((result) {
          if (result != null) {
            _canvas = result;
            notifyListeners();
          }
        });
      }
      notifyListeners();
    } on SpotifyApiException catch (e) {
      if (e.statusCode == 401) {
        _authFailureCount++;
        if (_authFailureCount >= 3) {
          // Token is truly gone (not just expired) — force re-login.
          _stopPolling();
          await _auth.clearTokens();
          _status = SpotifyStatus.unauthenticated;
          _playback = null;
          _authFailureCount = 0;
          notifyListeners();
        }
        // else: next poll will attempt a refresh via _getValidToken
      }
      // 404 = no active device; ignore until user starts playing
    } catch (_) {
      // Network error — next poll will retry
    } finally {
      _isBusy = false;
    }
  }

  Future<void> togglePlayPause() async {
    final wasPlaying = _playback?.isPlaying ?? false;
    _playback = _playback?.copyWith(
      isPlaying: !wasPlaying,
      fetchedAt: DateTime.now(),
    );
    notifyListeners();
    try {
      if (wasPlaying) {
        await _api.pause();
      } else {
        await _api.play();
      }
    } catch (_) {
      _playback = _playback?.copyWith(isPlaying: wasPlaying);
      notifyListeners();
    }
  }

  Future<void> skipNext() async {
    await _api.skipToNext();
    await Future.delayed(const Duration(milliseconds: 300));
    await _fetchPlayback();
  }

  Future<void> skipPrevious() async {
    await _api.skipToPrevious();
    await Future.delayed(const Duration(milliseconds: 300));
    await _fetchPlayback();
  }

  /// [fraction] is 0.0–1.0 relative to track duration.
  Future<void> seekTo(double fraction) async {
    final duration = _playback?.track?.durationMs ?? 0;
    if (duration == 0) return;
    final positionMs = (fraction * duration).round();
    _playback = _playback?.copyWith(
      progressMs: positionMs,
      fetchedAt: DateTime.now(),
    );
    notifyListeners();
    await _api.seekToPosition(positionMs);
  }

  Future<void> toggleShuffle() async {
    final next = !(_playback?.shuffleState ?? false);
    _playback = _playback?.copyWith(shuffleState: next);
    notifyListeners();
    await _api.setShuffle(state: next);
  }

  Future<void> cycleRepeat() async {
    const order = ['off', 'context', 'track'];
    final current = _playback?.repeatState ?? 'off';
    final next = order[(order.indexOf(current) + 1) % order.length];
    _playback = _playback?.copyWith(repeatState: next);
    notifyListeners();
    await _api.setRepeat(state: next);
  }

  Future<void> loadDevices() async {
    try {
      _devices = await _api.getDevices();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> transferTo(String deviceId) async {
    await _api.transferPlayback(deviceId, play: true);
    await Future.delayed(const Duration(milliseconds: 500));
    await loadDevices();
    await _fetchPlayback();
  }

  Future<void> playTrack(SpotifyTrack track) async {
    try {
      await _api.playTrackUri(track.uri);
      await Future.delayed(const Duration(milliseconds: 600));
      await _fetchPlayback();
    } catch (e) {
      debugPrint('[Spotify] playTrack error: $e');
    }
  }

  Future<void> playPlaylist(SpotifyPlaylist playlist) async {
    try {
      await _api.playContextUri(playlist.uri);
      await Future.delayed(const Duration(milliseconds: 600));
      await _fetchPlayback();
    } catch (e) {
      debugPrint('[Spotify] playPlaylist error: $e');
    }
  }

  Future<void> _fetchRecommendations() async {
    if (_recommendationsLoading) return;
    _recommendationsLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _api.getRecentlyPlayed(limit: 6),
        _api.getUserPlaylists(limit: 8),
      ]);
      _recentTracks = results[0] as List<SpotifyTrack>;
      _userPlaylists = results[1] as List<SpotifyPlaylist>;
    } catch (e) {
      debugPrint('[Spotify] fetchRecommendations error: $e');
    } finally {
      _recommendationsLoading = false;
      notifyListeners();
    }
  }

  // Retries for up to ~18 s because spotifyd needs a few seconds to register
  // as a Spotify Connect device after a fresh token is issued.
  Future<void> _autoTransferToIVI() async {
    for (var attempt = 0; attempt < 8; attempt++) {
      if (attempt > 0) await Future.delayed(const Duration(seconds: 3));
      if (!isAuthenticated) return;
      try {
        await loadDevices();
        final iviDevice =
            _devices.where((d) => d.name == 'Toyota IVI').firstOrNull;
        if (iviDevice != null) {
          // Transfer playback and resume — let Spotify continue whatever
          // was already playing rather than forcing a specific track URI
          // (which causes 400 while spotifyd session is still starting up).
          await _api.transferPlayback(iviDevice.id, play: true);
          debugPrint('[Spotify] transferred to Toyota IVI — resuming playback');
          await Future.delayed(const Duration(milliseconds: 800));
          await _fetchPlayback();
          return;
        }
        debugPrint('[Spotify] attempt $attempt – seen: '
            '${_devices.map((d) => d.name).toList()}');
      } catch (e) {
        debugPrint('[Spotify] autoTransfer attempt $attempt: $e');
      }
    }
    debugPrint('[Spotify] Toyota IVI not found after 8 attempts');
  }

  Future<String?> _getValidToken() async {
    if (await _auth.isTokenValid()) return _auth.getAccessToken();
    return _auth.refreshAccessToken();
  }

  @override
  void dispose() {
    _stopPolling();
    _connect.stop();
    _canvasService.dispose();
    super.dispose();
  }
}
