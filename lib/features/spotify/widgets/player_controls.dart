import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import '../providers/spotify_provider.dart';

class PlayerControls extends StatelessWidget {
  final bool compact;
  const PlayerControls({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final spotify = context.watch<SpotifyProvider>();

    final iconSize = compact ? r.iconXs : r.iconMd;
    final mainIconSize = compact ? r.iconSm : r.iconXl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => context.read<SpotifyProvider>().skipPrevious(),
        ),
        SizedBox(width: r.paddingSm),
        GestureDetector(
          onTap: () => context.read<SpotifyProvider>().togglePlayPause(),
          child: Icon(
            spotify.isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_filled_rounded,
            color: AppColor.action_color,
            size: mainIconSize,
          ),
        ),
        SizedBox(width: r.paddingSm),
        IconButton(
          icon: Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => context.read<SpotifyProvider>().skipNext(),
        ),
      ],
    );
  }
}
