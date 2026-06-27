# Robotaxi In-Cabin Dashboard — Software Requirements Specification

**Role:** Senior Automotive HMI Architect & Lead Flutter Engineer  
**Version:** 1.0  
**Status:** Draft

---

## 1. Overview

This document defines the software requirements for an autonomous vehicle (Robotaxi) in-cabin dashboard user interface. The design mimics a dual-zone Tesla Robotaxi layout: a 3D immersive environment viewport on the left, interactive passenger telematics on the right, and a unified media/climate control bar at the bottom.

### 1.1 Technical Stack

| Component              | Technology                                                                 |
|------------------------|----------------------------------------------------------------------------|
| Frontend Framework     | Flutter (embedded Linux / Android)                                         |
| 3D Vector Engine       | `filament_scene` (Google Filament PBR via Toyota tcna-packages v2.0)      |
| Data Source            | Autoware ROS 2 → rosbridge_suite WebSocket → JSON                         |
| State Management       | Provider (existing project pattern)                                        |
| Responsive Layout      | `flutter_screenutil` (existing project pattern)                            |

### 1.2 Target Hardware

- NVIDIA Orin SoM
- Automotive-grade display @ 1920×1080 60 fps
- Weston / Wayland compositor

---

## 2. Layout & Viewport Partitioning

The screen is divided into three logical zones:

```
┌─────────────────────────────────────────────────────┐
│  ┌──────────────────────────┬──────────────────────┐ │
│  │                          │   Passenger Profile   │ │
│  │                          ├──────────────────────┤ │
│  │  Left Zone (60%)         │   Ride Progress /     │ │
│  │  Immersive 3D Scene      │   Timeline Slider     │ │
│  │  (filament_scene)        ├──────────────────────┤ │
│  │                          │   Dynamic ETA Card    │ │
│  │                          ├──────────────────────┤ │
│  │                          │   Payment Split       │ │
│  │                          ├──────────────────────┤ │
│  │                          │   [ End Ride ] btn    │ │
│  └──────────────────────────┴──────────────────────┘ │
│  ┌─────────────────────────────────────────────────┐ │
│  │  Bottom Zone — Media / Time / Climate Controls  │ │
│  └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### 2.1 Left Zone — 3D Environment Viewport (60% width)

- Powered by `filament_scene` `SceneView` widget.
- Renders a textured ground plane (road surface) with lane markings as decals.
- Hosts a chase-cam following the ego vehicle from behind and slightly above.
- Spawns, updates, and despawns low-poly `.gltf`/`.glb` assets for tracked objects (cars, trucks, pedestrians).
- Draws the `/planning/scenario_planning/trajectory` as a glowing blue 3D polyline above the road.
- 2D HUD overlay (speed MPH, gear state) composited via `Stack` over the `SceneView`.

### 2.2 Right Zone — Passenger Interaction Panel (40% width)

- **Passenger Profile Card** — avatar, name, ride type.
- **Ride Progress Slider** — timeline from pickup → destination with animated position marker.
- **Dynamic ETA Card** — minutes remaining, distance remaining, estimated arrival time.
- **Payment Split Card** — fare breakdown, split-fare toggle.
- **End Ride Button** — primary action, triggers ride completion.

### 2.3 Bottom Zone — Status & Control Bar (full width, fixed height)

Persistent row containing:
- Media playback controls (play/pause, track info, volume).
- Local time display.
- Climate comfort controls (target temperature, fan speed, seat heater toggle).

---

## 3. Data Pipeline

### 3.1 WebSocket Connection

- **Endpoint:** `ws://<autoware-host>:9090` (rosbridge default).
- **Protocol:** JSON via `rosbridge_suite` protocol v2.0.
- **Topics subscribed:**

| Autoware Topic                                 | JSON Mapping            | Update Frequency | Purpose                  |
|------------------------------------------------|--------------------------|------------------|--------------------------|
| `/localization/kinematic_state`                | `kinematic_state`        | 30–50 Hz         | Speed & gear overlay     |
| `/perception/object_recognition/objects`       | `detected_objects`       | 10–20 Hz         | 3D bounding box entities |
| `/planning/scenario_planning/trajectory`       | `trajectory`             | 10 Hz            | Path prediction polyline |

### 3.2 Message Schema (JSON)

```jsonc
// /localization/kinematic_state
{
  "op": "subscribe",
  "topic": "/localization/kinematic_state",
  "msg": {
    "twist": { "linear": { "x": 15.5 } },      // m/s
    "gear": 1                                     // 0=park, 1=drive, -1=reverse
  }
}

// /perception/object_recognition/objects
{
  "op": "subscribe",
  "topic": "/perception/object_recognition/objects",
  "msg": {
    "objects": [
      {
        "id": 3,
        "classification": "car",                  // "car", "truck", "pedestrian"
        "pose": {
          "position": { "x": 25.0, "y": -3.5, "z": 0.0 },
          "orientation": {                        // quaternion
            "x": 0.0, "y": 0.0, "z": 0.707, "w": 0.707
          }
        },
        "dimensions": { "x": 4.5, "y": 2.0, "z": 1.5 }  // width, length, height
      }
    ]
  }
}

// /planning/scenario_planning/trajectory
{
  "op": "subscribe",
  "topic": "/planning/scenario_planning/trajectory",
  "msg": {
    "points": [
      { "x": 0.0, "y": 0.0, "z": 0.0 },
      { "x": 1.0, "y": 0.0, "z": 0.0 },
      ...
    ]
  }
}
```

### 3.3 Data Parsing Pipeline

```
WebSocket Stream (raw JSON)
    │
    ▼
Isolate / Compute worker — parse & deserialize
    │
    ▼
Provider (ChangeNotifier) — holds latest state
    │
    ▼
Widget tree — rebuilds via Consumer/Selector
    │
    ▼
filament_scene queueFrameTask — update transforms
```

**Performance constraints:**
- JSON parsing must not block the UI thread → use `compute()` or a dedicated Dart isolate.
- Filament entity updates are queued via `FilamentViewApi.queueFrameTask()` which defers to the native render thread.
- Object cleanup: entities not updated for >2 seconds are despawned (visibility off or removed).

---

## 4. 3D Scene Logic

### 4.1 Ego Vehicle

- Loaded as a `GlbModel.asset` (e.g., `assets/models/robotaxi/ego_vehicle.glb`).
- Positioned at world origin `(0, 0, 0)`; obstacle positions are relative offsets.
- Orientation updated from `kinematic_state` twist + any heading estimate.

### 4.2 Chase Camera

- Fixed offset: `distance=12m`, `height=5m`, `lookAt=(0,0,0)`.
- Implemented as a `Camera` in `filament_scene` with an orbit point following ego.
- Updated in `onUpdateFrame` to track ego vehicle position.

### 4.3 Tracked Objects (Cars, Trucks, Pedestrians)

- One low-poly `.glb` asset per classification type.
- On first detection: instantiate via `GlbModel` with `instancingMode: ModelInstancingType.instanced`.
- On each frame: `filamentView.setEntityTransformPosition(id, xyz)` + `setEntityTransformRotation(id, quat)` + `setEntityTransformScale(id, dims)`.
- On missing for >2 seconds: `filamentView.turnOffVisualForEntity(id)`, then remove from tracking map and recycle ID.

### 4.4 Trajectory Path

- Rendered as a series of small cubes or cylinder shapes (or a single chain of instances) along waypoints.
- Color: glowing blue (custom material via `changeMaterialParameter`).
- Updated every frame from the latest trajectory topic data.

### 4.5 Ground Plane & Environment

- A large textured `Plane` shape for road surface.
- Optional skybox via `ColorSkybox` or `HdrSkybox`.

---

## 5. Performance & Memory Management

### 5.1 Object Pool

- Pre-allocate GUIDs for up to 64 tracked objects.
- Free list / in-use list pattern (same as the `_radarSegmentPieceGUID` pattern in example).

### 5.2 Cleanup Timer

- Each tracked object gets a `lastSeenAt` timestamp.
- A periodic check (every 1s) despawns objects with `age > 2s`.

### 5.3 Frame Budget

- Target: 60 fps steady.
- `filament_scene` operations are offloaded to the native C++ engine; Dart-side work is limited to deserialization and transform math.

---

## 6. File Structure

```
lib/features/robotaxi/
├── models/
│   ├── autoware_messages.dart      # ROS 2 topic message types
│   └── trip_models.dart            # Passenger-facing trip state
├── services/
│   ├── autoware_ws_client.dart     # WebSocket rosbridge client
│   └── mock_autoware_data.dart     # Simulated data for development
├── providers/
│   ├── autoware_data_provider.dart # ChangeNotifier for 3D scene data
│   └── trip_provider.dart          # ChangeNotifier for trip state
├── widgets/
│   ├── robotaxi_layout.dart        # Root layout (60/40 split + bottom bar)
│   ├── environment_view.dart       # filament_scene wrapper + HUD overlay
│   ├── trip_panel.dart             # Right-side passenger interaction panel
│   └── bottom_control_bar.dart     # Media/time/climate bar
└── screens/
    └── robotaxi_screen.dart        # Entry point (wraps layout + providers)
```

---

## 7. Dependencies (pubspec.yaml additions)

```yaml
dependencies:
  filament_scene:
    git:
      url: https://github.com/toyota-connected/tcna-packages.git
      ref: v2.0
      path: packages/filament_scene
  web_socket_channel: ^3.0.0
```

---

## 8. Future Considerations

- **Runtime material editing:** Use `filament_scene`'s material parameter API to color-code objects by classification or speed.
- **Collision detection:** The Autoware prediction module can trigger visual highlights on high-risk objects.
- **Weather / time-of-day:** Dynamic skybox and fog settings via the Filament exposure and fog API.
- **Haptic feedback:** Request haptic patterns when vehicle state transitions (pull-over, arrival).

---

*End of SRS*
