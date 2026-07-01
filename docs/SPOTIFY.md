# Spotify Integration

## Overview

The Spotify feature provides:
- Now-playing display with album art and progress
- Spotify Canvas animated video backgrounds
- Play/pause, skip, seek, shuffle, repeat controls
- Device transfer to the IVI speaker (Toyota IVI via spotifyd)
- QR-code OAuth login via a Cloudflare relay

## Architecture

```
Phone (Spotify app)
  │  Spotify Connect
  ▼
spotifyd (IVI daemon) ──► PipeWire ──► speakers
  │  writes credentials
  ▼
SpotifyCanvasService ──► librespot token ──► Canvas gRPC API
  │  video URL
  ▼
MusicCard (Flutter) ──► video_player_linux ──► GStreamer (muted, fakesink)
```

## Spotify App Registration

Create an app at https://developer.spotify.com/dashboard and add the redirect URI:

```
http://127.0.0.1:8080/callback
```

Copy the Client ID and Client Secret into `.env`:

```
SPOTIFY_CLIENT_ID=your_client_id
SPOTIFY_CLIENT_SECRET=your_client_secret
```

## OAuth Login Flow

1. User taps "Connect Spotify" on the home screen.
2. A QR code is shown, pointing to the Cloudflare relay (`cloudflare/worker.js`).
3. The passenger scans the QR on their phone, logs in on Spotify's site.
4. Spotify redirects to the relay, which forwards the `?code=` back to the car.
5. The car exchanges the code for tokens and starts polling playback.

## Cloudflare Relay

The relay avoids needing the car's IP to be reachable from the internet.

Deploy with:
```bash
cd cloudflare
npx wrangler deploy
```

Configuration is in `cloudflare/wrangler.jsonc`. The worker URL must match the
`redirectUri` used in `SpotifyAuthService`.

## spotifyd Setup

spotifyd acts as a Spotify Connect speaker, streaming audio to PipeWire.

### Install
```bash
cargo install spotifyd
# or download a binary release from https://github.com/Spotifyd/spotifyd
```

### Config (`~/.config/spotifyd/spotifyd.conf`)
```toml
[global]
device_name = "Toyota IVI"
backend = "pulseaudio"   # or "pipe_wire" if PipeWire native backend is available
bitrate = 320
device_type = "speaker"
```

### Credentials

Credentials are written automatically by `SpotifyConnectService` after OAuth login.
The librespot token cache lives in `~/.cache/spotifyd/`.

### Manual start (for debugging)
```bash
spotifyd --no-daemon --verbose
```

## Spotify Canvas

Canvas videos are short looping clips shown behind album art while a song plays.

- `SpotifyCanvasService` fetches the Canvas URL via the librespot gRPC API.
- Canvas videos are played muted by `MusicCard` using `video_player_linux`.
- `VIDEO_PLAYER_AUDIO_SINK=fakesink` must be set at launch (see `DEVELOPMENT.md`).

### Song-transition crash fix

When spotifyd claims the PipeWire device for a new song, GStreamer's `pipewiresink`
posts an error from the GLib thread. ivi-homescreen's `BinaryMessenger` is not
thread-safe from non-platform threads, causing a SIGSEGV.

Fix: `VIDEO_PLAYER_AUDIO_SINK=fakesink` — canvas video is muted, so no real audio
sink is needed.

Secondary defence: `MusicCard` subscribes to `videoEventsFor()` after the player
reaches READY state and tears it down cleanly on any pipeline error, before the
error propagates to `BinaryMessenger`.
