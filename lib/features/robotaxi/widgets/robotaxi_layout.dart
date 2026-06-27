import 'package:flutter/material.dart';

import 'bottom_control_bar.dart';
import 'environment_view.dart';
import 'trip_panel.dart';

class RobotaxiLayout extends StatelessWidget {
  const RobotaxiLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: const RobotaxiEnvironment(),
              ),
              const VerticalDivider(width: 1, color: Colors.white12),
              const Expanded(flex: 4, child: TripPanel()),
            ],
          ),
        ),
        const BottomControlBar(),
      ],
    );
  }
}
