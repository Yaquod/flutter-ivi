import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ivi/services/connectivity_service.dart';

class ConnectivityIcon extends StatelessWidget {
  const ConnectivityIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ConnectivityService().ConnectivityStream,
      builder: (context, snapshot) {
        final results = snapshot.data ?? [ConnectivityResult.none];

        if (results.contains(ConnectivityResult.none)) {
          return const Icon(
            Icons.signal_cellular_connected_no_internet_4_bar,
            color: Colors.redAccent,
            size: 20,
          );
        } else if (results.contains(ConnectivityResult.wifi)) {
          return const Icon(Icons.wifi, color: Colors.white, size: 20);
        } else if (results.contains(ConnectivityResult.mobile)) {
          return const Icon(
            Icons.signal_cellular_4_bar,
            color: Colors.white,
            size: 20,
          );
        }

        return const Icon(
          Icons.signal_cellular_0_bar,
          color: Colors.white24,
          size: 20,
        );
      },
    );
  }
}
