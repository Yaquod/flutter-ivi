import 'package:grpc/grpc.dart';
import '../proto/vehicle_frame.pbgrpc.dart';
import '../proto/vehicle_frame.pb.dart';

class ClusterClient {
  late ClientChannel _channel;
  late ClusterServiceClient _stub;

  ClusterClient({required String host, required int port}) {
    _channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = ClusterServiceClient(_channel);
  }

  Stream<VehicleFrame> subscribe({String clientId = 'flutter-ivi'}) {
    final request = SubscribeRequest()..clientId = clientId;
    return _stub.subscribe(request);
  }

  Future<VehicleFrame> getLatestFrame({String clientId = 'flutter-ivi'}) {
    final request = SubscribeRequest()..clientId = clientId;
    return _stub.getLatestFrame(request);
  }

  Future<void> shutdown() => _channel.shutdown();
}