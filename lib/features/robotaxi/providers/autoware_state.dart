import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_ivi/proto/vehicle_frame.pb.dart' as pb;

import '../models/perception_models.dart';
import '../services/zenoh_isolate.dart';

/// Holds the latest deserialized frames from all 4 Zenoh topics.
/// Runs the subscriber in a dedicated background [Isolate].
class AutowareState extends ChangeNotifier {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _isolateSendPort;
  StreamSubscription? _sub;

  pb.VehicleFrame? cluster;
  PerceptionFrame? perception;
  PlanningFrame? planning;
  TripFrame? trip;

  static const _objectTtl = Duration(seconds: 2);
  final Map<int, DateTime> _lastSeen = {};

  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(zenohIsolateMain, _receivePort!.sendPort);

    _sub = _receivePort!.listen((msg) {
      if (msg is SendPort) {
        _isolateSendPort = msg;
        return;
      }
      switch (msg) {
        case ClusterMsg(:final frame):
          cluster = frame;
        case PerceptionMsg(:final frame):
          perception = frame;
          _updateLastSeen(frame);
          _gcExpiredObjects();
        case PlanningMsg(:final frame):
          planning = frame;
        case TripMsg(:final frame):
          trip = frame;
      }
      notifyListeners();
    });
  }

  void _updateLastSeen(PerceptionFrame frame) {
    final now = DateTime.now();
    for (final obj in frame.surroundingObjects) {
      _lastSeen[obj.id] = now;
    }
  }

  void _gcExpiredObjects() {
    if (perception == null) return;
    final now = DateTime.now();
    final active = perception!.surroundingObjects.where((o) {
      final seen = _lastSeen[o.id];
      return seen != null && now.difference(seen) < _objectTtl;
    }).toList();

    if (active.length < perception!.surroundingObjects.length) {
      perception = PerceptionFrame(
        stampNs: perception!.stampNs,
        seq: perception!.seq,
        surroundingObjects: active,
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _isolateSendPort?.send(null);
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    super.dispose();
  }

  double get speedMph {
    final v = cluster?.velocity;
    if (v == null) return 0;
    return v.speedMps * 2.23694;
  }

  String get gearLabel {
    final g = cluster?.gear ?? pb.GearState.GEAR_UNKNOWN;
    switch (g.value) {
      case 1: return 'P';
      case 2: return 'R';
      case 3: return 'N';
      case 4: return 'D';
      default: return '—';
    }
  }

  double get tripProgress => trip?.tripState == TripState.completed ? 1.0 : 0.6;
}
