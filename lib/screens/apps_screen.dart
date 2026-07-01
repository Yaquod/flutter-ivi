import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';
import 'package:flutter_ivi/features/spotify/widgets/player_controls.dart';
import 'package:flutter_ivi/features/spotify/widgets/device_selector_sheet.dart';
import 'package:flutter_ivi/features/spotify/widgets/spotify_login_dialog.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final spotify = context.watch<SpotifyProvider>();

    if (!spotify.isAuthenticated) {
      return _LoginState(r: r, spotify: spotify);
    }

    return Padding(
      padding: r.edgeInsetsSym(h: 0, v: 0),
      child: Row(
        children: [
          Expanded(child: _AlbumPanel(r: r, spotify: spotify)),
          SizedBox(width: r.w(24)),
          Expanded(child: _ControlPanel(r: r, spotify: spotify)),
        ],
      ),
    );
  }
}

class _LoginState extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyProvider spotify;

  const _LoginState({required this.r, required this.spotify});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.music_note,
            color: AppColor.secondary_text_dark,
            size: r.iconXl,
          ),
          SizedBox(height: r.paddingLg),
          Text(
            'Spotify',
            style: TextStyle(
              color: Colors.white,
              fontSize: r.fontXxl,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: r.paddingSm),
          Text(
            'Connect your Spotify account to play music\nthrough the car speakers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: r.fontMd,
            ),
          ),
          SizedBox(height: r.paddingXl),
          GestureDetector(
            onTap: () {
              final authUrl = context.read<SpotifyProvider>().beginAuth();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SpotifyLoginDialog(
                  authUrl: authUrl,
                  onCodeReceived: (code) =>
                      context.read<SpotifyProvider>().completeAuth(code),
                ),
              );
            },
            child: Container(
              padding: r.edgeInsetsSym(h: 48, v: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954),
                borderRadius: BorderRadius.circular(r.radiusMd),
              ),
              child: Text(
                'Connect Spotify',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: r.fontLg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumPanel extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyProvider spotify;

  const _AlbumPanel({required this.r, required this.spotify});

  @override
  Widget build(BuildContext context) {
    final track = spotify.currentTrack;

    return GlassCard(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: r.edgeInsetsAll(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: r.sp(300),
              height: r.sp(300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.action_color.withValues(alpha: 0.3),
                    blurRadius: r.sp(40),
                    spreadRadius: r.sp(8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(r.radiusLg),
                child: track?.albumArtUrl != null
                    ? Image.network(
                        track!.albumArtUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _artPlaceholder(r),
                      )
                    : _artPlaceholder(r),
              ),
            ),
            SizedBox(height: r.paddingXl),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangeNotifierProvider.value(
                  value: spotify,
                  child: const DeviceSelectorSheet(),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.speaker,
                    color: AppColor.secondary_text_dark,
                    size: r.iconXs,
                  ),
                  SizedBox(width: r.paddingSm),
                  Text(
                    spotify.playback?.device?.name ?? 'No device',
                    style: TextStyle(
                      color: AppColor.secondary_text_dark,
                      fontSize: r.fontSm,
                    ),
                  ),
                  SizedBox(width: r.paddingXs),
                  Icon(
                    Icons.expand_more,
                    color: AppColor.secondary_text_dark,
                    size: r.iconXs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artPlaceholder(ResponsiveLayout r) => Container(
        color: Colors.white.withValues(alpha: 0.05),
        child: Icon(
          Icons.music_note,
          color: AppColor.secondary_text_dark,
          size: r.iconXl,
        ),
      );
}

class _ControlPanel extends StatefulWidget {
  final ResponsiveLayout r;
  final SpotifyProvider spotify;

  const _ControlPanel({required this.r, required this.spotify});

  @override
  State<_ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<_ControlPanel> {
  double? _seekOverride;

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final spotify = widget.spotify;
    final track = spotify.currentTrack;
    final playback = spotify.playback;

    final durationMs = track?.durationMs ?? 1;
    final progressMs = _seekOverride != null
        ? (_seekOverride! * durationMs).round()
        : (playback?.estimatedProgressMs ?? 0);
    final fraction = (progressMs / durationMs).clamp(0.0, 1.0);

    return GlassCard(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: r.edgeInsetsAll(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              track?.name ?? 'Nothing Playing',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.fontXxl,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: r.paddingSm),
            Text(
              track?.artistName ?? '',
              style: TextStyle(
                color: AppColor.action_color,
                fontSize: r.fontLg,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: r.paddingXs),
            Text(
              track?.albumName ?? '',
              style: TextStyle(
                color: AppColor.secondary_text_dark,
                fontSize: r.fontMd,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: r.paddingXl),
            Row(
              children: [
                Text(
                  _formatMs(progressMs),
                  style: TextStyle(
                    color: AppColor.secondary_text_dark,
                    fontSize: r.fontXs,
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: r.sp(3),
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: r.sp(6),
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: r.sp(12),
                      ),
                    ),
                    child: Slider(
                      value: _seekOverride ?? fraction.toDouble(),
                      activeColor: AppColor.action_color,
                      inactiveColor: Colors.white12,
                      onChangeStart: (v) => setState(() => _seekOverride = v),
                      onChanged: (v) => setState(() => _seekOverride = v),
                      onChangeEnd: (v) {
                        context.read<SpotifyProvider>().seekTo(v);
                        setState(() => _seekOverride = null);
                      },
                    ),
                  ),
                ),
                Text(
                  _formatMs(durationMs),
                  style: TextStyle(
                    color: AppColor.secondary_text_dark,
                    fontSize: r.fontXs,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.paddingLg),
            const PlayerControls(compact: false),
            SizedBox(height: r.paddingLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle_rounded,
                    color: (playback?.shuffleState ?? false)
                        ? AppColor.action_color
                        : AppColor.secondary_text_dark,
                    size: r.iconSm,
                  ),
                  onPressed: () =>
                      context.read<SpotifyProvider>().toggleShuffle(),
                ),
                SizedBox(width: r.paddingXl),
                IconButton(
                  icon: Icon(
                    _repeatIcon(playback?.repeatState),
                    color: (playback?.repeatState ?? 'off') != 'off'
                        ? AppColor.action_color
                        : AppColor.secondary_text_dark,
                    size: r.iconSm,
                  ),
                  onPressed: () =>
                      context.read<SpotifyProvider>().cycleRepeat(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _repeatIcon(String? state) => switch (state) {
        'track' => Icons.repeat_one_rounded,
        _ => Icons.repeat_rounded,
      };

  String _formatMs(int ms) {
    final s = ms ~/ 1000;
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }
}
