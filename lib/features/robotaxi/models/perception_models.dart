library;

/// Manual Dart models for Autoware perception data.
/// The protobuf-generated file only covers VehicleFrame;
/// these types mirror the PerceptionFrame, PlanningFrame, and TripFrame
/// from vehicle_frame.proto lines 237–381.

enum ObjectClass {
  unknown(0),
  car(1),
  truck(2),
  bus(3),
  trailer(4),
  motorcycle(5),
  bicycle(6),
  pedestrian(7),
  animal(8);

  final int value;
  const ObjectClass(this.value);
  static ObjectClass fromValue(int v) =>
      ObjectClass.values.firstWhere((e) => e.value == v, orElse: () => ObjectClass.unknown);
}

class BoundingBox {
  final double length;
  final double height;
  final double width;
  const BoundingBox({required this.length, required this.height, required this.width});
}

class ObjectVelocity {
  final double vx;
  final double vy;
  const ObjectVelocity({required this.vx, required this.vy});
}

class Pose {
  final double x, y, z;
  const Pose({required this.x, required this.y, required this.z});
}

class SurroundingObject {
  final int id;
  final ObjectClass objectClass;
  final BoundingBox boundingBox;
  final ObjectVelocity velocity;
  final double heading;
  final Pose pose;

  const SurroundingObject({
    required this.id,
    required this.objectClass,
    required this.boundingBox,
    required this.velocity,
    required this.heading,
    required this.pose,
  });
}

class PerceptionFrame {
  final int stampNs;
  final int seq;
  final List<SurroundingObject> surroundingObjects;

  const PerceptionFrame({
    required this.stampNs,
    required this.seq,
    required this.surroundingObjects,
  });
}

class TrajectoryPoint {
  final double x, y, z;
  final double longitudinalVelocityMps;
  const TrajectoryPoint({
    required this.x, required this.y, required this.z,
    this.longitudinalVelocityMps = 0,
  });
}

class PlanningFrame {
  final int stampNs;
  final int seq;
  final List<TrajectoryPoint> trajectoryPoints;
  final double targetSpeedMps;
  final double maxSpeedMps;
  final double remainingDistanceM;
  final double remainingTimeS;

  const PlanningFrame({
    required this.stampNs,
    required this.seq,
    required this.trajectoryPoints,
    this.targetSpeedMps = 0,
    this.maxSpeedMps = 0,
    this.remainingDistanceM = 0,
    this.remainingTimeS = 0,
  });
}

enum TripState {
  idle(0),
  publishingInitialPose(1),
  waitingLocalisation(2),
  publishingGoal(3),
  waitingRoute(4),
  engaging(5),
  running(6),
  completed(7),
  failed(8);

  final int value;
  const TripState(this.value);
  static TripState fromValue(int v) =>
      TripState.values.firstWhere((e) => e.value == v, orElse: () => TripState.idle);
}

class TripFrame {
  final int stampNs;
  final int seq;
  final TripState tripState;
  final double goalDistanceM;

  const TripFrame({
    required this.stampNs,
    required this.seq,
    required this.tripState,
    this.goalDistanceM = 0,
  });
}
