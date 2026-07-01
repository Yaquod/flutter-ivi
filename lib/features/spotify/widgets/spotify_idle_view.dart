import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';
import 'package:flutter_ivi/features/spotify/models/spotify_track.dart';
import 'package:flutter_ivi/features/spotify/models/spotify_playlist.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class SpotifyIdleView extends StatelessWidget {
  const SpotifyIdleView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final spotify = context.watch<SpotifyProvider>();

    if (spotify.recommendationsLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
                color: Color(0xFF1DB954), strokeWidth: 2),
            SizedBox(height: r.paddingSm),
            Text('Loading your music…',
                style: TextStyle(
                    color: AppColor.secondary_text_dark, fontSize: r.fontXs)),
          ],
        ),
      );
    }

    final tracks = spotify.recentTracks;
    final playlists = spotify.userPlaylists;

    return SingleChildScrollView(
      padding: r.edgeInsetsAll(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tracks.isNotEmpty) ...[
            _SectionLabel(r: r, text: 'Recently Played'),
            SizedBox(height: r.paddingXs),
            SizedBox(
              height: r.sp(110),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tracks.length,
                separatorBuilder: (_, __) => SizedBox(width: r.paddingSm),
                itemBuilder: (ctx, i) =>
                    _TrackChip(r: r, track: tracks[i]),
              ),
            ),
            SizedBox(height: r.paddingMd),
          ],
          if (playlists.isNotEmpty) ...[
            _SectionLabel(r: r, text: 'Your Playlists'),
            SizedBox(height: r.paddingXs),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlists.length.clamp(0, 6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: r.paddingXs,
                crossAxisSpacing: r.paddingXs,
                childAspectRatio: 3.2,
              ),
              itemBuilder: (ctx, i) =>
                  _PlaylistChip(r: r, playlist: playlists[i]),
            ),
          ],
          if (tracks.isEmpty && playlists.isEmpty)
            Center(
              child: Padding(
                padding: r.edgeInsetsAll(24),
                child: Text(
                  'Open Spotify on your phone to start playing,\nthen it will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColor.secondary_text_dark,
                      fontSize: r.fontXs),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final ResponsiveLayout r;
  final String text;
  const _SectionLabel({required this.r, required this.text});

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppColor.secondary_text_dark,
          fontSize: r.fontXs * 0.85,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      );
}

// ── Track chip ────────────────────────────────────────────────────────────────

class _TrackChip extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyTrack track;
  const _TrackChip({required this.r, required this.track});

  @override
  Widget build(BuildContext context) {
    final spotify = context.read<SpotifyProvider>();
    final size = r.sp(80);

    return GestureDetector(
      onTap: () => spotify.playTrack(track),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(r.radiusSm),
                  child: track.albumArtUrl != null
                      ? Image.network(track.albumArtUrl!,
                          width: size, height: size, fit: BoxFit.cover)
                      : _ArtPlaceholder(size: size, r: r),
                ),
                Positioned(
                  right: r.sp(4),
                  bottom: r.sp(4),
                  child: Container(
                    width: r.sp(22),
                    height: r.sp(22),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: r.sp(14)),
                  ),
                ),
              ],
            ),
            SizedBox(height: r.sp(4)),
            Text(
              track.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fontXs,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              track.artistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColor.secondary_text_dark,
                  fontSize: r.fontXs * 0.85),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Playlist chip ─────────────────────────────────────────────────────────────

class _PlaylistChip extends StatelessWidget {
  final ResponsiveLayout r;
  final SpotifyPlaylist playlist;
  const _PlaylistChip({required this.r, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final spotify = context.read<SpotifyProvider>();
    final imgSize = r.sp(32);

    return GestureDetector(
      onTap: () => spotify.playPlaylist(playlist),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(r.radiusSm),
        ),
        padding: EdgeInsets.symmetric(horizontal: r.sp(8), vertical: r.sp(4)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(r.sp(4)),
              child: playlist.imageUrl != null
                  ? Image.network(playlist.imageUrl!,
                      width: imgSize, height: imgSize, fit: BoxFit.cover)
                  : _ArtPlaceholder(size: imgSize, r: r),
            ),
            SizedBox(width: r.sp(8)),
            Expanded(
              child: Text(
                playlist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: r.fontXs * 0.9,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared placeholder ────────────────────────────────────────────────────────

class _ArtPlaceholder extends StatelessWidget {
  final double size;
  final ResponsiveLayout r;
  const _ArtPlaceholder({required this.size, required this.r});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(r.radiusSm),
        ),
        child: Icon(Icons.music_note,
            color: AppColor.secondary_text_dark, size: size * 0.4),
      );
}
