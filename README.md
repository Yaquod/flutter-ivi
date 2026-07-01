# flutter_ivi

A Flutter-based In-Vehicle Infotainment (IVI)application designed for embedded Linux Software-Defined Vehicle (SDV) targets. It runs as a guest in an SDV hypervisor domain and communicates via gRPC with an autonomous driving stack (Autoware + ROS 2) operating in a separate hypervisor domain, streaming real-time vehicle telemetry to render a live digital IVI.

## Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                   SDV Hypervisor                     │
│                                                      │
│  ┌─────────────────────┐   ┌──────────────────────┐  │
│  │  IVI Domain         │   │  Autonomous Domain   │  │
│  │  (Embedded Linux)   │   │  (ROS 2 / Autoware)  │  │
│  │                     │   │                      │  │
│  │  flutter_ivi  ◄─────┼───┼── autoware-agent     │  │
│  │  (gRPC client)      │   │  (gRPC server)       │  │
│  └─────────────────────┘   └──────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

## Prerequisites

- [meta-flutter workspace-automation](https://github.com/meta-flutter/workspace-automation) for the embedded Flutter toolchain
- [autoware-agent](https://github.com/Yaquod/autoware-agent.git) with a configured Autoware + ROS 2 environment

## Getting Started

### 1. Set Up the Embedded Flutter Workspace

Clone and configure the meta-flutter workspace:

```bash
git clone https://github.com/meta-flutter/workspace-automation
cd workspace-automation
./flutter_workspace.py
source ${FLUTTER_WORKSPACE}/setup_env.sh
```

### 2. Run the IVI Application

In the same terminal (with the Flutter environment sourced), navigate to the app and run:

```bash
VIDEO_PLAYER_AUDIO_SINK=fakesink flutter run -d desktop-homescreen
```

`VIDEO_PLAYER_AUDIO_SINK=fakesink` is required to prevent a SIGSEGV crash when Spotify
Canvas videos transition between songs. See [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md)
for the full run command (including `LD_PRELOAD` for the CEF WebView plugin).

To open in VS Code for debugging:

```bash
code .
```

### 3. Set Up the Autoware Agent (gRPC Server)

The IVI app connects to the `autoware-agent` gRPC server, which bridges Autoware and ROS 2 data to the IVI domain. Refer to the [autoware-agent README](https://github.com/Yaquod/autoware-agent) for full Autoware and ROS 2 setup instructions.

```bash
git clone https://github.com/Yaquod/autoware-agent.git
cd autoware-agent
```

Build the agent:

```bash
colcon build --packages-select vehicle_autoware_agent \
  --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo
```

Run the agent with map configuration:

```bash
./install/vehicle_autoware_agent/bin/autoware_agent \
  --map-path install/vehicle_autoware_agent/share/autoware_agent/maps/nishishinjuku_routes.yaml
```

The gRPC server can run on localhost or inside a VM / separate hypervisor domain, depending on your SDV setup.

## Features

- **Digital Cluster** — live speed, gear, battery, and ADAS telemetry from Autoware via gRPC
- **Spotify Integration** — now-playing, Canvas video backgrounds, playback controls, QR OAuth login
- **Navigation** — turn-by-turn overlay on the cluster display
- **Settings** — sound, display, and system preferences panels
- **Responsive UI** — scales to any resolution; base design at 1920×1080

## Documentation

| Doc | Contents |
|---|---|
| [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md) | Build, run, CEF setup, env vars |
| [`docs/SPOTIFY.md`](docs/SPOTIFY.md) | Spotify Canvas, spotifyd, Cloudflare relay |
| [`docs/DYNAMIC_THEME.md`](docs/DYNAMIC_THEME.md) | Album-art palette theming |

## License

See [LICENSE](LICENSE) for details.