import 'package:flutter/material.dart';
import 'package:flutter_ivi/features/map/widgets/base_mab.dart';
import 'package:flutter_ivi/features/map/widgets/side_controls.dart';
import 'package:flutter_ivi/features/map/widgets/navigation_panel.dart';
import 'package:flutter_ivi/features/map/widgets/arrival_panel.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double screenScale = 1.4;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseMab(
        overlayChild: Stack(
          children: [
            const Positioned(
              top: 30,
              right: 30,
              child: SideControls(scale: screenScale),
            ),

            Positioned(
              top: 30,
              left: 30,
              child: _buildLargeMicButton(screenScale),
            ),

            const Positioned(
              bottom: 30,
              left: 30,
              width: 380,
              child: NavigationPanel(scale: screenScale),
            ),

            const Positioned(
              bottom: 30,
              right: 30,
              width: 380,
              child: ArrivalPanel(scale: screenScale),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeMicButton(double scale) {
    return Container(
      padding: EdgeInsets.all(8 * scale),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(
        Icons.mic_none_outlined,
        color: Colors.white,
        size: 18 * scale,
      ),
    );
  }
}
