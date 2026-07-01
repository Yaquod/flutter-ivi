import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class AlbumPalette {
  final Color background; // very dark — full-screen bg
  final Color surface;    // slightly lighter — card bg
  final Color accent;     // vibrant — progress bar, buttons
  final Color onSurface;  // text color (white or black based on bg luminance)

  const AlbumPalette({
    required this.background,
    required this.surface,
    required this.accent,
    required this.onSurface,
  });

  static const fallback = AlbumPalette(
    background: Color(0xFF080814),
    surface: Color(0xFF12122a),
    accent: Color(0xFF1DB954),
    onSurface: Colors.white,
  );
}

class AlbumPaletteService {
  final Map<String, AlbumPalette> _cache = {};

  Future<AlbumPalette> extract(String? url) async {
    if (url == null || url.isEmpty) return AlbumPalette.fallback;
    if (_cache.containsKey(url)) return _cache[url]!;
    try {
      final generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(url),
        size: const Size(150, 150),
        maximumColorCount: 20,
      );
      final palette = _build(generator);
      _cache[url] = palette;
      return palette;
    } catch (_) {
      return AlbumPalette.fallback;
    }
  }

  AlbumPalette _build(PaletteGenerator g) {
    final raw = g.dominantColor?.color ??
        g.vibrantColor?.color ??
        const Color(0xFF1a1a2e);

    final accent = g.vibrantColor?.color ??
        g.lightVibrantColor?.color ??
        const Color(0xFF1DB954);

    final background = _toBackground(raw);
    final surface = _toSurface(raw);
    final luminance = background.computeLuminance();
    final onSurface = luminance > 0.4 ? Colors.black87 : Colors.white;

    return AlbumPalette(
      background: background,
      surface: surface,
      accent: accent,
      onSurface: onSurface,
    );
  }

  static Color _toBackground(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withSaturation((hsl.saturation * 0.85).clamp(0.0, 1.0))
        .withLightness(hsl.lightness.clamp(0.04, 0.16))
        .toColor();
  }

  static Color _toSurface(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withSaturation((hsl.saturation * 0.7).clamp(0.0, 1.0))
        .withLightness(hsl.lightness.clamp(0.12, 0.26))
        .toColor();
  }
}
