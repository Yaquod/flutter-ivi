import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';
import 'package:flutter_ivi/features/spotify/services/album_palette_service.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.select<SpotifyProvider, AlbumPalette>(
      (s) => s.palette,
    );

    return TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      tween: ColorTween(end: palette.background),
      builder: (context, animatedBg, _) {
        final bg = animatedBg ?? palette.background;
        final mid = Color.lerp(bg, palette.surface, 0.55) ?? bg;

        return Stack(
          children: [
            // ── Animated full-IVI album-color gradient ──────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bg, mid, bg],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // ── Subtle radial accent glow (bottom-right = music card) ───
            TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
              tween: ColorTween(end: palette.surface),
              builder: (context, animatedSurface, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.85, 0.85),
                      radius: 1.1,
                      colors: [
                        (animatedSurface ?? palette.surface)
                            .withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── Backdrop blur (same as before) ──────────────────────────
            Positioned.fill(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────
            SafeArea(child: child),
          ],
        );
      },
    );
  }
}
