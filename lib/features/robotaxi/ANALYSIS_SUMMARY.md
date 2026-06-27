# autoware-agent Source Inspection — Analysis Summary

## Repository Layout
`/home/wafdy/gp/autoware-agent/`
- `proto/` — Protobuf schemas (`vehicle_frame.proto`, `vehicle_gateway.proto`)
- `src/` — C++ agent with 4 bridge classes + Zenoh publisher
- `tests/` — Integration tests

## Zenoh Topic Keys (4 publishers, all at 60 Hz)

| Bridge          | Zenoh Key            | Protobuf Type      | Contents |
|-----------------|----------------------|--------------------|----------|
| `ClusterBridge` | `autoware/cluster`   | `VehicleFrame`     | Speed, gear, steering, battery, motion, MRM, ADAS counts, ETA, turn signal, control mode, surround objects (2D) |
| `PerceptionBridge` | `autoware/perception` | `PerceptionFrame` | Full 3D bounding boxes (id, class, x/y/z, heading, dims, velocity), point cloud, occupancy grid, traffic lights |
| `PlanningBridge` | `autoware/planning`  | `PlanningFrame`    | Trajectory points (x/y/z + velocity), lane trajectory, full route, velocity/steering factors, target/max speed, ETA, routing state, scenario |
| `TripBridge`    | `autoware/trip`      | `TripFrame`        | Trip state machine (IDLE→RUNNING→COMPLETED/FAILED), localization state, operation mode, component health, start/goal poses |

## Architecture Pattern
Each bridge:
1. Subscribes to relevant ROS 2 topics (15+ topics total across all bridges)
2. Posts callbacks to a Boost.Asio strand thread
3. Publishes serialized protobuf at 60 Hz via `ZenohPublisher::publish(SerializeAsString())`
4. `ZenohPublisher` wraps `zenoh::Publisher::put()` on a `zenoh::Session`

## Zenoh Session Config (from `AutowareApp.cpp:44-46`)
```
scouting/multicast/enabled = false
transport/shared_memory/enabled = false
listen/endpoints = ["udp/0.0.0.0:7447"]
```

## Key Protobuf → Dart Field Mappings (from `vehicle_frame.pb.dart`)

### VehicleFrame → Telematics Overlay
- `velocity.speedMps` → MPH conversion (`speedMps * 2.23694`)
- `gear` → P/R/N/D label
- `controlMode` → Auto/Manual indicator
- `batteryPct` → Battery bar
- `eta.remainingDistanceM` + `remainingTimeS` → ETA card

### PerceptionFrame → 3D Scene Objects
- `surroundingObjects[]` → filament_scene entities:
  - `id` → entity tracking key
  - `objectClass` → model variant (0=UNKNOWN, 1=CAR, 2=TRUCK, 3=BUS, 4=TRAILER, 5=MOTORCYCLE, 6=BICYCLE, 7=PEDESTRIAN, 8=ANIMAL)
  - `objectPose.x/y/z` → world position (relative to ego)
  - `heading` → yaw rotation
  - `boundingBox.length/height/width` → entity scale
  - `objectVelocity.vxObject/vyObject` → motion indicator

### PlanningFrame → Trajectory Path
- `trajectoryPoints[]` → illuminated blue 3D polyline in filament_scene:
  - `x/y/z` → waypoint positions
  - `longitudinalVelocityMps` → color intensity modulation

### TripFrame → Trip State Machine
- `tripState` (0-8) → UI state transitions
- `startX/Y/Z`, `goalX/Y/Z` → pickup/destination relative poses
- `goalDistanceM` → remaining distance
- `componentHealth[]` → system diagnostics panel
