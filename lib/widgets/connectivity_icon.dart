import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ivi/services/connectivity_service.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class ConnectivityIcon extends StatelessWidget {
  const ConnectivityIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return StreamBuilder(
      stream: ConnectivityService().ConnectivityStream,
      builder: (context, snapshot) {
        final results = snapshot.data ?? [ConnectivityResult.none];

        if (results.contains(ConnectivityResult.none)) {
          return Icon(
            Icons.signal_cellular_connected_no_internet_4_bar,
            color: Colors.redAccent,
            size: r.iconXs,
          );
        } else if (results.contains(ConnectivityResult.wifi)) {
          return Icon(Icons.wifi, color: Colors.white, size: r.iconXs);
        } else if (results.contains(ConnectivityResult.mobile)) {
          return Icon(
            Icons.signal_cellular_4_bar,
            color: Colors.white,
            size: r.iconXs,
          );
        }

        return Icon(
          Icons.signal_cellular_0_bar,
          color: Colors.white24,
          size: r.iconXs,
        );
      },
    );
  }
}
