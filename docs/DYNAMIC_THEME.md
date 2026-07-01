# Dynamic Album Art Theme

The IVI adapts its entire color scheme to match the currently playing Spotify track's album art — similar to the iOS Music player. When the track changes, the background, music card, and accent colors all animate smoothly to the new palette.

---

## How It Works

```
Album art URL
     │
     ▼
AlbumPaletteService.extract(url)
     │  palette_generator reads 150×150 px of the image
     │  extracts dominant + vibrant swatches
     │
     ▼
AlbumPalette { background, surface, accent, onSurface }
     │
     ├──► SpotifyProvider.palette  (exposed via ChangeNotifier)
     │
     ├──► HomeScreen  → AnimatedContainer background + radial glow
     │
     └──► MusicCard   → AnimatedContainer card gradient + glow shadow
                         _ProgressBar uses palette.accent color
```

---

## Files

| File | Role |
|------|------|
| `lib/features/spotify/services/album_palette_service.dart` | Extracts and caches `AlbumPalette` from a URL |
| `lib/features/spotify/providers/spotify_provider.dart` | Holds `_palette`, re-extracts when `albumArtUrl` changes |
| `lib/screens/home_screen.dart` | Full-screen animated gradient background |
| `lib/widgets/music_card.dart` | Album-colored card + glowing shadow when playing |

---

## AlbumPalette Fields

```dart
class AlbumPalette {
  final Color background; // very dark version of dominant color → full-screen bg
  final Color surface;    // slightly lighter → music card gradient
  final Color accent;     // vibrant swatch → progress bar, buttons
  final Color onSurface;  // white or black depending on bg luminance → text
}
```

`AlbumPalette.fallback` is used when no track is playing:
- `background`: deep navy `#080814`
- `accent`: Spotify green `#1DB954`

---

## Adding Dynamic Colors to a New Widget

Read the palette from the provider:

```dart
// Option A — watch full provider (rebuilds on any change)
final palette = context.watch<SpotifyProvider>().palette;

// Option B — select only palette (rebuilds only when palette changes)
final palette = context.select<SpotifyProvider, AlbumPalette>((s) => s.palette);
```

Use it:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 900),
  curve: Curves.easeInOut,
  color: palette.background,
  child: ...,
)
```

---

## Color Extraction Logic

`AlbumPaletteService` uses `palette_generator` to analyse the album art:

1. Downloads a 150×150 thumbnail of the album art (cached, not re-downloaded)
2. Extracts up to 20 color swatches
3. Picks `dominantColor` for `background` and `surface`
4. Picks `vibrantColor` for `accent`
5. Darkens `background` to lightness 4–16% (always readable against white text)
6. Darkens `surface` to lightness 12–26% (card layer, slightly lighter than bg)
7. Computes text color: white if bg luminance < 0.4, else black

Results are cached in memory by URL — each unique album art is only processed once per app session.

---

## Animation

All color transitions use `AnimatedContainer` with:
- **Duration**: 900ms
- **Curve**: `Curves.easeInOut`

This gives a smooth crossfade when the track changes. The glow underneath the music card also fades in/out with the same timing.

---

## Tuning Colors

All color math is in `AlbumPaletteService`:

```dart
// Make background darker → lower the second clamp value
static Color _toBackground(Color c) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withSaturation((hsl.saturation * 0.85).clamp(0.0, 1.0))
      .withLightness(hsl.lightness.clamp(0.04, 0.16))  // ← 0.16 = max lightness
      .toColor();
}

// Make card surface lighter → raise the second clamp value
static Color _toSurface(Color c) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withSaturation((hsl.saturation * 0.7).clamp(0.0, 1.0))
      .withLightness(hsl.lightness.clamp(0.12, 0.26))  // ← 0.26 = max lightness
      .toColor();
}
```

---

## Dependencies

```yaml
# pubspec.yaml
dependencies:
  palette_generator: ^0.3.3
```

Install:
```bash
flutter pub get
```

---

## Spotify OAuth Scopes Required

The album art URL comes from the playback state API. No extra scopes are needed — `user-read-currently-playing` already returns the album art URL.
