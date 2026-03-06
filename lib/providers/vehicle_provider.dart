import 'dart:async';
import 'package:flutter/foundation.dart';
import '../proto/vehicle_frame.pb.dart';
import '../services/cluster_client.dart';
class VehicleFrameNotifier extends ChangeNotifier {
  final ClusterClient _client;
  StreamSubscription<VehicleFrame>? _subscription;
  VehicleFrame? _latest;
  String? _error;
  bool _isConnecting = false;  // ← add this guard

  VehicleFrame? get latest => _latest;
  String? get error => _error;

  VehicleFrameNotifier(this._client) {
    _startListening();
  }

  void _startListening() {
    if (_isConnecting) return;  // ← prevent multiple simultaneous connections
    _isConnecting = true;

    _subscription?.cancel();
    print('🔌 Starting gRPC subscription...');

    _subscription = _client.subscribe().listen(
      (frame) {
        _isConnecting = false;
        print('📦 Frame received: seq=${frame.seq} speed=${frame.velocity.speedKmh}');
        _latest = frame;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _isConnecting = false;
        print('❌ Stream error: $e');
        _error = e.toString();
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), _startListening);
      },
      onDone: () {
        _isConnecting = false;
        print('✅ Stream done');
        Future.delayed(const Duration(seconds: 1), _startListening);
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _client.shutdown();
    super.dispose();
  }
}