import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/autoware_state.dart';
import '../providers/trip_provider.dart';
import '../widgets/robotaxi_layout.dart';

class RobotaxiScreen extends StatefulWidget {
  const RobotaxiScreen({super.key});

  @override
  State<RobotaxiScreen> createState() => _RobotaxiScreenState();
}

class _RobotaxiScreenState extends State<RobotaxiScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AutowareState()..start()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: const Scaffold(
        backgroundColor: Color(0xFF0a0e1a),
        body: RobotaxiLayout(),
      ),
    );
  }
}
