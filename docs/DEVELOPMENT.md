# Development Guide

## Prerequisites

- Flutter SDK (channel stable, ≥ 3.9)
- ivi-homescreen built with video_player and webview plugins
- GStreamer runtime libraries on target (aarch64 or host)
- CEF binary (128.x) extracted alongside the ivi-homescreen binary

## Building ivi-homescreen

```bash
cd /home/wafdy/workspace-automation/app/ivi-homescreen

cmake -B build \
  -DBUILD_PLUGIN_VIDEO_PLAYER_LINUX=ON \
  -DBUILD_PLUGIN_WEBVIEW_FLUTTER_VIEW=ON \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build -j$(nproc)
```

## Running on the IVI target

```bash
VIDEO_PLAYER_AUDIO_SINK=fakesink \
LD_PRELOAD=/home/wafdy/workspace-automation/app/ivi-homescreen-plugins/plugins/webview_flutter_view/third_party/cef_binary_128.4.9+g9840ad9+chromium-128.0.6613.120_linuxarm64_minimal/Release/libcef.so \
flutter run -d desktop-homescreen
```

`VIDEO_PLAYER_AUDIO_SINK=fakesink` — canvas video is always muted; using `fakesink`
instead of the default `pipewiresink` prevents GStreamer from competing with spotifyd
for the PipeWire audio device, which would cause a SIGSEGV on song transitions.

## CEF Setup (one-time, per machine)

### 1. libcef in the linker cache
```bash
CEF_DIR=/home/wafdy/workspace-automation/app/ivi-homescreen-plugins/plugins/webview_flutter_view/third_party/cef_binary_128.4.9+g9840ad9+chromium-128.0.6613.120_linuxarm64_minimal/Release

echo "$CEF_DIR" | sudo tee /etc/ld.so.conf.d/cef.conf
sudo ldconfig
```

### 2. chrome-sandbox SUID binary
```bash
sudo cp "$CEF_DIR/chrome-sandbox" /usr/local/bin/chrome-sandbox
sudo chown root:root /usr/local/bin/chrome-sandbox
sudo chmod 4755 /usr/local/bin/chrome-sandbox
```

### 3. CEF resource symlinks (in the Flutter build output directory)
```bash
BUILD_DIR=$(flutter build linux --no-pub 2>/dev/null; find build/linux -name 'bundle' -type d | head -1)
ln -sf "$CEF_DIR/icudtl.dat"          "$BUILD_DIR/icudtl.dat"
ln -sf "$CEF_DIR/v8_context_snapshot.bin" "$BUILD_DIR/v8_context_snapshot.bin"
ln -sf "$CEF_DIR/Resources"            "$BUILD_DIR/Resources"
```

## libproxy Fix

If the app hangs on network requests due to a libproxy D-Bus timeout:
```bash
sudo apt-get remove --purge libproxy1v5 libproxy-tools
```

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `VIDEO_PLAYER_AUDIO_SINK` | `pipewiresink` | Override GStreamer audio sink for video_player. Set to `fakesink` on IVI to avoid PipeWire device conflicts. |

## Screen Resolution

Base design resolution: **1920×1080**. All sizes go through `ResponsiveLayout`
(`r.w()`, `r.h()`, `r.sp()`) so the UI scales to any resolution automatically.
