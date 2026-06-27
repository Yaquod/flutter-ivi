import 'dart:async';
import 'dart:isolate';

import 'package:flutter_ivi/proto/vehicle_frame.pb.dart' as pb;

import '../models/perception_models.dart';
import 'zenoh_subscriber.dart';

/// Messages sent from the Zenoh isolate to the main isolate via SendPort.
/// Each is wrapped in a typed envelope so the receiver can dispatch by type.
sealed class ZenohIsolateMsg {
  const ZenohIsolateMsg();
}

class ClusterMsg extends ZenohIsolateMsg {
  final pb.VehicleFrame frame;
  const ClusterMsg(this.frame);
}

class PerceptionMsg extends ZenohIsolateMsg {
  final PerceptionFrame frame;
  const PerceptionMsg(this.frame);
}

class PlanningMsg extends ZenohIsolateMsg {
  final PlanningFrame frame;
  const PlanningMsg(this.frame);
}

class TripMsg extends ZenohIsolateMsg {
  final TripFrame frame;
  const TripMsg(this.frame);
}

/// Entry point for the background isolate.
void zenohIsolateMain(SendPort sendPort) {
  final sub = MockZenohSubscriber();

  final subs = <StreamSubscription>[
    sub.clusterStream.listen((f) => sendPort.send(ClusterMsg(f))),
    sub.perceptionStream.listen((f) => sendPort.send(PerceptionMsg(f))),
    sub.planningStream.listen((f) => sendPort.send(PlanningMsg(f))),
    sub.tripStream.listen((f) => sendPort.send(TripMsg(f))),
  ];

  sub.connect();

  final shutdownPort = ReceivePort();
  sendPort.send(shutdownPort.sendPort);
  shutdownPort.listen((_) {
    for (final s in subs) {
      s.cancel();
    }
    sub.disconnect();
    Isolate.exit();
  });
}
