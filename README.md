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
flutter run -d desktop-homescreen
```

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

## License

See [LICENSE](LICENSE) for details.