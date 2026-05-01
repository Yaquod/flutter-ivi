import 'package:flutter/material.dart';
import 'package:flutter_ivi/screens/cluster_screen.dart';
import '../proto/vehicle_frame.pb.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
  final emptyFrame = VehicleFrame();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ClusterView(frame: emptyFrame ), 
      ),
    );
  }
}

