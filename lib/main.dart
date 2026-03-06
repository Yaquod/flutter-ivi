// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cluster_client.dart';
import 'providers/vehicle_provider.dart';
import 'screens/cluster_screen.dart';

void main() {
  final client = ClusterClient(host: '192.168.64.7', port: 50052);

  runApp(
    ChangeNotifierProvider(
      create: (_) => VehicleFrameNotifier(client),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Cluster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ClusterScreen(),
    );
  }
}