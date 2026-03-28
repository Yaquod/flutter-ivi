import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Stream<List<ConnectivityResult>> get ConnectivityStream =>
      Connectivity().onConnectivityChanged;
}
