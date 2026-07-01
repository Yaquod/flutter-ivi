import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ivi/screens/cluster_screen.dart';
import 'package:provider/provider.dart';
import 'services/cluster_client.dart';
import 'providers/vehicle_provider.dart';

void main() async{
  final client = ClusterClient(host: 'localhost', port: 50052);

  //await dotenv.load(fileName: ".env");

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
      home: ClusterScreen(),
    );
  }
}