import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart' as vpi;
import 'package:flutter_ivi/ui_components/glass_card.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';
import 'package:flutter_ivi/features/spotify/services/spotify_callback_server.dart';
import 'package:flutter_ivi/features/spotify/services/spotify_relay_client.dart';
import 'package:flutter_ivi/features/spotify/widgets/spotify_qr_login_dialog.dart';
import 'package:flutter_ivi/features/spotify/widgets/spotify_browse_sheet.dart';
import 'package:flutter_ivi/features/spotify/models/spotify_track.dart';
import 'package:flutter_ivi/features/spotify/services/album_palette_service.dart';
import 'package:flutter_ivi/features/spotify/widgets/player_controls.dart';

const _kGreen = Color(0xFF1DB954);

class MusicCard extends StatelessWidget {
  final VoidCallback? onTap;
  const MusicCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final spotify = context.watch<SpotifyProvider>();
    final palette = spotify.palette;
    final isPlaying = spotify.currentTrack != null;

    final canvasUrl = spotify.canvasUrl;
    final canvasIsVideo = spotify.canvasIsVideo;

    Widget body;
    if (!spotify.isAuthenticated) {
      body = _LoginPrompt(r: r);
    } else if (isPlaying) {
      body = _PlayerView(r: r, spotify: spotify, palette: palette, canvasUrl: canvasUrl, canvasIsVideo: canvasIsVideo);
    } else {
      body = _IdleView(r: r);
    }

    // When playing: album-colored card with glow; otherwise: glass card
    if (isPlaying) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.surface,
              palette.background,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: palette.accent.withValues(alpha: 0.25),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r.radiusXl),
          child: body,
        ),
      );
    }

    return GlassCard(
      borderRadius: BorderRadius.circular(r.radiusXl),
      child: body,
    );
  }
}

// ── Player view (landscape: art left, info+controls right) ────────────────────

class _PlayerView extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyProvider spotify;
  final AlbumPalette palette;
  final String? canvasUrl;
  final bool canvasIsVideo;
  const _PlayerView({required this.r, required this.spotify, required this.palette, this.canvasUrl, this.canvasIsVideo = false});

  @override
  Widget build(BuildContext context) {
    final track = spotify.currentTrack!;
    final playback = spotify.playback;

    final isVideo = canvasUrl != null && canvasIsVideo;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Canvas video / album art background ─────────────────────────
        if (isVideo)
          _CanvasVideo(url: canvasUrl!)
        else if (track.albumArtUrl != null)
          Image.network(
            track.albumArtUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),

        // Dark overlay so text stays readable over any background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withValues(alpha: isVideo ? 0.55 : 0.70),
                Colors.black.withValues(alpha: isVideo ? 0.30 : 0.50),
              ],
            ),
          ),
        ),

        // ── Player controls ──────────────────────────────────────────────
        Padding(
      padding: r.edgeInsetsAll(14),
      child: Row(
        children: [
          // ── Album art ───────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(r.radiusMd),
            child: track.albumArtUrl != null
                ? Image.network(
                    track.albumArtUrl!,
                    width: r.sp(160),
                    height: r.sp(160),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _artPlaceholder(r),
                  )
                : _artPlaceholder(r),
          ),

          SizedBox(width: r.paddingMd),

          // ── Track info + controls ────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title row + browse button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r.fontMd,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: r.sp(2)),
                          Text(
                            track.artistName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColor.secondary_text_dark,
                              fontSize: r.fontSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Browse icon
                    IconButton(
                      onPressed: () => showSpotifyBrowseSheet(context),
                      icon: Icon(Icons.queue_music_rounded,
                          color: Colors.white54, size: r.iconSm),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: r.paddingSm),

                // Progress bar
                if (playback != null && track.durationMs > 0) ...[
                  _ProgressBar(r: r, spotify: spotify, track: track, accent: palette.accent),
                  SizedBox(height: r.paddingSm),
                ],

                // Controls
                PlayerControls(compact: false),
              ],
            ),
          ),
        ],
      ),
        ),
      ],
    );
  }

  Widget _artPlaceholder(ResponsiveLayout r) => Container(
        width: r.sp(160),
        height: r.sp(160),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(r.radiusMd),
        ),
        child: Icon(Icons.music_note,
            color: AppColor.secondary_text_dark, size: r.iconMd),
      );
}

// ── Thin progress bar ─────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyProvider spotify;
  final SpotifyTrack track;
  final Color accent;

  const _ProgressBar(
      {required this.r, required this.spotify, required this.track, required this.accent});

  String _fmt(int ms) {
    final s = ms ~/ 1000;
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = spotify.playback!.estimatedProgressMs;
    final total = track.durationMs;
    final fraction = (progress / total).clamp(0.0, 1.0);

    return Column(
      children: [
        GestureDetector(
          onTapDown: (d) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;
            final f = (d.localPosition.dx / box.size.width).clamp(0.0, 1.0);
            spotify.seekTo(f);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: r.sp(3),
              backgroundColor: Colors.white12,
              color: accent,
            ),
          ),
        ),
        SizedBox(height: r.sp(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_fmt(progress),
                style: TextStyle(
                    color: Colors.white38, fontSize: r.fontXs * 0.85)),
            Text(_fmt(total),
                style: TextStyle(
                    color: Colors.white38, fontSize: r.fontXs * 0.85)),
          ],
        ),
      ],
    );
  }
}

// ── Idle view (logged in, nothing playing) ────────────────────────────────────

class _IdleView extends StatelessWidget {
  final ResponsiveLayout r;
  const _IdleView({required this.r});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.sp(48),
            height: r.sp(48),
            decoration: const BoxDecoration(
                color: _kGreen, shape: BoxShape.circle),
            child: Icon(Icons.music_note,
                color: Colors.white, size: r.sp(28)),
          ),
          SizedBox(height: r.paddingSm),
          Text(
            'Spotify Connected',
            style: TextStyle(
                color: Colors.white,
                fontSize: r.fontSm,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: r.paddingXs),
          Text(
            'Pick something to play',
            style: TextStyle(
                color: AppColor.secondary_text_dark, fontSize: r.fontXs),
          ),
          SizedBox(height: r.paddingMd),
          GestureDetector(
            onTap: () => showSpotifyBrowseSheet(context),
            child: Container(
              padding:
                  r.edgeInsetsSym(h: 20, v: 10),
              decoration: BoxDecoration(
                color: _kGreen,
                borderRadius: BorderRadius.circular(r.radiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.queue_music_rounded,
                      color: Colors.white, size: r.iconXs),
                  SizedBox(width: r.sp(6)),
                  Text(
                    'Browse Music',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: r.fontSm),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Login prompt ──────────────────────────────────────────────────────────────

class _LoginPrompt extends StatelessWidget {
  final ResponsiveLayout r;
  const _LoginPrompt({required this.r});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.music_note_outlined,
              color: AppColor.secondary_text_dark, size: r.iconMd),
          SizedBox(height: r.paddingSm),
          Text(
            'Music',
            style: TextStyle(
                color: Colors.white,
                fontSize: r.fontSm,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: r.paddingXs),
          Text(
            'Scan QR to connect Spotify',
            style: TextStyle(
                color: AppColor.secondary_text_dark, fontSize: r.fontXs),
          ),
          SizedBox(height: r.paddingMd),
          GestureDetector(
            onTap: () => _showLogin(context),
            child: Container(
              padding: r.edgeInsetsSym(h: 20, v: 10),
              decoration: BoxDecoration(
                color: _kGreen,
                borderRadius: BorderRadius.circular(r.radiusMd),
              ),
              child: Text(
                'Connect',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: r.fontSm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogin(BuildContext context) async {
    final spotify = context.read<SpotifyProvider>();
    final relayUrl = dotenv.env['SPOTIFY_RELAY_URL'] ?? '';
    try {
      if (relayUrl.isNotEmpty) {
        final client = SpotifyRelayClient(relayUrl);
        final (:qrUrl, :codeFuture) = spotify.beginAuthViaRelay(client);
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SpotifyQrLoginDialog(
            authUrl: qrUrl,
            codeFuture: codeFuture,
            onCodeReceived: (code) => spotify.completeAuth(code),
          ),
        );
      } else {
        final localIp = await SpotifyCallbackServer.getLocalIp();
        await SpotifyCallbackServer.ensureCert(localIp);
        final redirectUri =
            'https://$localIp:${SpotifyCallbackServer.kPort}/callback';
        final server = SpotifyCallbackServer();
        final authUrl = spotify.beginAuth(redirectUri: redirectUri);
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SpotifyQrLoginDialog(
            authUrl: authUrl,
            codeFuture: server.waitForCode(),
            onCodeReceived: (code) => spotify.completeAuth(code),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('[MusicCard] _showLogin error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Spotify error: $e')));
      }
    }
  }
}

// ── Canvas looping video background ──────────────────────────────────────────

class _CanvasVideo extends StatefulWidget {
  final String url;
  const _CanvasVideo({required this.url});
  @override
  State<_CanvasVideo> createState() => _CanvasVideoState();
}

class _CanvasVideoState extends State<_CanvasVideo> {
  int? _textureId;
  int? _pendingTextureId; // textureId of in-flight _load before setState
  int _loadGen = 0;        // incremented each _load; stale loads check this
  double _videoWidth = 1080;
  double _videoHeight = 1920;
  bool _ready = false;
  StreamSubscription<vpi.VideoEvent>? _errorSub; // listens for post-play errors

  // Use stderr so these appear even if Flutter's stdout pipe is buffered/lost.
  static void _log(String msg) => stderr.writeln('[Canvas] $msg');

  @override
  void initState() {
    super.initState();
    _log('initState url=${widget.url}');
    _load(widget.url);
  }

  Future<void> _load(String url) async {
    final gen = ++_loadGen;
    _log('_load#$gen START url=$url');
    final platform = vpi.VideoPlayerPlatform.instance;
    int? textureId;
    try {
      textureId = await platform.createWithOptions(vpi.VideoCreationOptions(
        dataSource: vpi.DataSource(
          sourceType: vpi.DataSourceType.network,
          uri: url,
        ),
        viewType: vpi.VideoViewType.textureView,
      ));
      _log('#$gen createWithOptions => textureId=$textureId');

      if (textureId == null || gen != _loadGen || !mounted) {
        _log('#$gen stale/unmounted/null after create — disposing $textureId');
        if (textureId != null) platform.dispose(textureId);
        return;
      }
      _pendingTextureId = textureId;

      await platform.setLooping(textureId, true);
      await platform.setVolume(textureId, 0.0);

      if (gen != _loadGen || !mounted) {
        _log('#$gen stale/unmounted before play — disposing $textureId');
        _pendingTextureId = null;
        platform.dispose(textureId);
        return;
      }

      // video_player_linux only fires 'initialized' after the first decoded
      // video frame, which the GStreamer pipeline produces only when in
      // PLAYING state. Call play() first so frames arrive, then wait.
      await platform.play(textureId);
      _log('#$gen play() called textureId=$textureId');

      _log('#$gen waiting for initialized event textureId=$textureId');
      final event = await platform
          .videoEventsFor(textureId)
          .firstWhere((e) => e.eventType == vpi.VideoEventType.initialized)
          .timeout(const Duration(seconds: 15));
      _log('#$gen initialized! textureId=$textureId size=${event.size}');

      if (gen != _loadGen || !mounted) {
        _log('#$gen stale/unmounted after initialized — disposing $textureId');
        _pendingTextureId = null;
        platform.dispose(textureId);
        return;
      }

      _pendingTextureId = null;
      setState(() {
        _textureId = textureId;
        _videoWidth = event.size?.width ?? 1080;
        _videoHeight = event.size?.height ?? 1920;
        _ready = true;
      });
      _log('#$gen READY textureId=$textureId ${_videoWidth}x$_videoHeight');

      // Keep a live subscription to catch C++ pipeline errors (e.g. audio
      // device lost). Without this listener, errors sent via event_sink_ from
      // GStreamer's bus thread can reach a NULL Dart-side sink and crash the
      // embedder's BinaryMessenger. Receiving the error here lets us tear down
      // the player cleanly instead.
      _errorSub?.cancel();
      final capturedId = textureId;
      _errorSub = platform.videoEventsFor(capturedId).listen(
        null,
        onError: (dynamic e) {
          _log('pipeline error textureId=$capturedId gen=$gen: $e');
          if (mounted && _textureId == capturedId) {
            _cancelAndDispose();
            setState(() {});
          }
        },
        cancelOnError: true,
      );
    } catch (e, st) {
      _log('#$gen ERROR for $url: $e\n$st');
      _pendingTextureId = null;
      if (textureId != null) {
        try { platform.dispose(textureId); } catch (_) {}
      }
    }
  }

  void _cancelAndDispose() {
    _loadGen++; // makes any running _load bail out on next gen check
    final id = _textureId;
    final pending = _pendingTextureId;
    _textureId = null;
    _pendingTextureId = null;
    _ready = false;
    _errorSub?.cancel();
    _errorSub = null;
    final platform = vpi.VideoPlayerPlatform.instance;
    if (pending != null && pending != id) {
      _log('_cancelAndDispose: disposing pending=$pending');
      platform.dispose(pending);
    }
    if (id != null) {
      _log('_cancelAndDispose: deferring dispose id=$id');
      // Defer disposal by two frames so the raster thread finishes any
      // in-flight render of Texture(id) before C++ tears down the GL texture.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _log('_cancelAndDispose: deferred dispose id=$id');
          platform.dispose(id);
        });
      });
    }
  }

  @override
  void didUpdateWidget(_CanvasVideo old) {
    super.didUpdateWidget(old);
    _log('didUpdateWidget: ${old.url} → ${widget.url}');
    if (old.url != widget.url) {
      _cancelAndDispose();
      setState(() {}); // ensure _ready = false is reflected in build
      _load(widget.url);
    }
  }

  @override
  void dispose() {
    _log('dispose textureId=$_textureId pending=$_pendingTextureId');
    _cancelAndDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _textureId == null) return const SizedBox.shrink();
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoWidth,
          height: _videoHeight,
          child: Texture(textureId: _textureId!),
        ),
      ),
    );
  }
}
