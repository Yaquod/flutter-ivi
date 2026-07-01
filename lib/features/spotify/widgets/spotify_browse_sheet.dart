import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';
import 'package:flutter_ivi/features/spotify/models/spotify_track.dart';
import 'package:flutter_ivi/features/spotify/models/spotify_playlist.dart';
import 'package:flutter_ivi/constants/app_color.dart';

const _kBg = Color(0xFF121212);
const _kGreen = Color(0xFF1DB954);
const _kSurface = Color(0xFF1E1E1E);

void showSpotifyBrowseSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<SpotifyProvider>(),
      child: const _BrowseSheet(),
    ),
  );
}

class _BrowseSheet extends StatelessWidget {
  const _BrowseSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      decoration: const BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _handle(),
          _header(context),
          const Divider(color: Colors.white12, height: 1),
          const Expanded(child: _SheetBody()),
        ],
      ),
    );
  }

  Widget _handle() => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Widget _header(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.library_music, color: _kGreen, size: 22),
            const SizedBox(width: 10),
            const Text(
              'Your Music',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.white54, size: 22),
            ),
          ],
        ),
      );
}

class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    final spotify = context.watch<SpotifyProvider>();
    final tracks = spotify.recentTracks;
    final playlists = spotify.userPlaylists;

    if (spotify.recommendationsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _kGreen, strokeWidth: 2),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        if (tracks.isNotEmpty) ...[
          _sectionLabel('Recently Played'),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (ctx, i) => _TrackTile(track: tracks[i]),
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (playlists.isNotEmpty) ...[
          _sectionLabel('Your Playlists'),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlists.length.clamp(0, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 4.0,
            ),
            itemBuilder: (ctx, i) => _PlaylistTile(playlist: playlists[i]),
          ),
        ],
        if (tracks.isEmpty && playlists.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Play something on Spotify first,\nthen browse here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionLabel(String text) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      );
}

// ── Track tile ────────────────────────────────────────────────────────────────

class _TrackTile extends StatefulWidget {
  final SpotifyTrack track;
  const _TrackTile({required this.track});
  @override
  State<_TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<_TrackTile> {
  bool _busy = false;

  Future<void> _play() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await context.read<SpotifyProvider>().playTrack(widget.track);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Open Spotify on your phone first to activate a device'),
          backgroundColor: Color(0xFF333333),
        ));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _play,
      child: SizedBox(
        width: 86,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.track.albumArtUrl != null
                      ? Image.network(widget.track.albumArtUrl!,
                          width: 86, height: 86, fit: BoxFit.cover)
                      : _artPlaceholder(86),
                ),
                if (_busy)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black38,
                      child: Center(
                          child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: _kGreen, strokeWidth: 2),
                      )),
                    ),
                  ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                        color: _kGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              widget.track.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              widget.track.artistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Playlist tile ─────────────────────────────────────────────────────────────

class _PlaylistTile extends StatefulWidget {
  final SpotifyPlaylist playlist;
  const _PlaylistTile({required this.playlist});
  @override
  State<_PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<_PlaylistTile> {
  bool _busy = false;

  Future<void> _play() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await context.read<SpotifyProvider>().playPlaylist(widget.playlist);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Open Spotify on your phone first to activate a device'),
          backgroundColor: Color(0xFF333333),
        ));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _play,
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(8)),
              child: widget.playlist.imageUrl != null
                  ? Image.network(widget.playlist.imageUrl!,
                      width: 52, height: 52, fit: BoxFit.cover)
                  : _artPlaceholder(52),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playlist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${widget.playlist.tracksTotal} tracks',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      color: _kGreen, strokeWidth: 2),
                ),
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

Widget _artPlaceholder(double size) => Container(
      width: size,
      height: size,
      color: Colors.white10,
      child: Icon(Icons.music_note,
          color: AppColor.secondary_text_dark, size: size * 0.4),
    );
