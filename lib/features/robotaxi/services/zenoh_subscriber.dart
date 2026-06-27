import 'dart:async';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter_ivi/proto/vehicle_frame.pb.dart' as pb;

import '../models/perception_models.dart';

/// Abstract interface for Zenoh subscription.
abstract class ZenohSubscriber {
  Stream<pb.VehicleFrame> get clusterStream;
  Stream<PerceptionFrame> get perceptionStream;
  Stream<PlanningFrame> get planningStream;
  Stream<TripFrame> get tripStream;

  Future<void> connect({String endpoint = 'udp/0.0.0.0:7447'});
  Future<void> disconnect();
}

/// Mock subscriber emitting synthetic data at ~60 Hz for development.
class MockZenohSubscriber implements ZenohSubscriber {
  final _clusterCtrl = StreamController<pb.VehicleFrame>.broadcast();
  final _perceptionCtrl = StreamController<PerceptionFrame>.broadcast();
  final _planningCtrl = StreamController<PlanningFrame>.broadcast();
  final _tripCtrl = StreamController<TripFrame>.broadcast();

  @override
  Stream<pb.VehicleFrame> get clusterStream => _clusterCtrl.stream;
  @override
  Stream<PerceptionFrame> get perceptionStream => _perceptionCtrl.stream;
  @override
  Stream<PlanningFrame> get planningStream => _planningCtrl.stream;
  @override
  Stream<TripFrame> get tripStream => _tripCtrl.stream;

  Timer? _timer;
  int _seq = 0;

  @override
  Future<void> connect({String endpoint = 'udp/0.0.0.0:7447'}) async {
    _timer = Timer.periodic(const Duration(milliseconds: 17), (_) => _emitFrame());
  }

  void _emitFrame() {
    final now = DateTime.now();
    final t = now.millisecondsSinceEpoch / 1000.0;

    _clusterCtrl.add(pb.VehicleFrame(
      stampNs: $fixnum.Int64(now.microsecondsSinceEpoch * 1000),
      seq: $fixnum.Int64(_seq++),
      velocity: pb.VelocityData(
        speedMps: 8.0 + (now.millisecond % 2000) / 1000 * 2,
        speedKmh: 28.8,
      ),
      gear: pb.GearState.GEAR_DRIVE,
      controlMode: pb.ControlMode.MODE_AUTO,
      batteryPct: 85.0,
      eta: pb.EtaData(remainingDistanceM: 8400, remainingTimeS: 1080),
      adas: pb.AdasSummary(
        obstacleCount: 4, pedestrianCount: 1, vehicleCount: 3,
        trafficLightGreen: true,
      ),
    ));

    _perceptionCtrl.add(PerceptionFrame(
      stampNs: now.microsecondsSinceEpoch * 1000,
      seq: _seq,
      surroundingObjects: List.generate(6, (i) {
        final osc = math.sin(t * 0.5 + i.toDouble()) * 3.0;
        return SurroundingObject(
          id: i + 1,
          objectClass: i == 1 ? ObjectClass.pedestrian : ObjectClass.car,
          boundingBox: BoundingBox(
            length: i == 1 ? 0.6 : 4.5,
            height: i == 1 ? 1.8 : 1.5,
            width: i == 1 ? 0.6 : 2.0,
          ),
          velocity: ObjectVelocity(vx: 2.0, vy: 0.0),
          heading: 0.0,
          pose: Pose(
            x: 10.0 + i * 8.0 + (t % 5) * 0.5,
            y: -3.0 + (i.isEven ? 1 : -1) * 2.0 + osc * 0.3,
            z: 0.0,
          ),
        );
      }),
    ));

    _planningCtrl.add(PlanningFrame(
      stampNs: now.microsecondsSinceEpoch * 1000,
      seq: _seq,
      trajectoryPoints: List.generate(80, (i) => TrajectoryPoint(
        x: i * 1.5,
        y: ((i * 0.15).floor() % 2 == 0 ? 0.0 : 2.0) + math.sin(i * 0.2) * 0.5,
        z: 0.0,
        longitudinalVelocityMps: 8.0,
      )),
      targetSpeedMps: 8.0,
      maxSpeedMps: 13.9,
      remainingDistanceM: 8400,
      remainingTimeS: 1080,
    ));

    _tripCtrl.add(TripFrame(
      stampNs: now.microsecondsSinceEpoch * 1000,
      seq: _seq,
      tripState: TripState.running,
      goalDistanceM: 8400,
    ));
  }

  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    await _clusterCtrl.close();
    await _perceptionCtrl.close();
    await _planningCtrl.close();
    await _tripCtrl.close();
  }
}

/// FFI-backed Zenoh subscriber (stub).
class FfiZenohSubscriber implements ZenohSubscriber {
  @override
  Stream<pb.VehicleFrame> get clusterStream => throw UnimplementedError('FFI not bound');
  @override
  Stream<PerceptionFrame> get perceptionStream => throw UnimplementedError('FFI not bound');
  @override
  Stream<PlanningFrame> get planningStream => throw UnimplementedError('FFI not bound');
  @override
  Stream<TripFrame> get tripStream => throw UnimplementedError('FFI not bound');

  @override
  Future<void> connect({String endpoint = 'udp/0.0.0.0:7447'}) async {
    // TODO: Open zenoh-c session, declare subscribers on 4 keys,
    //       deserialize protobuf bytes in a background isolate,
    //       pipe to broadcast streams.
  }

  @override
  Future<void> disconnect() async {
    // TODO: Close session, cancel subscriptions, free C allocations.
  }
}
