import 'package:flutter/material.dart';
import 'package:flutter_ivi/features/map/widgets/base_mab.dart';
import 'package:flutter_ivi/features/map/widgets/side_controls.dart';
import 'package:flutter_ivi/features/map/widgets/navigation_panel.dart';
import 'package:flutter_ivi/features/map/widgets/arrival_panel.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BaseMab(
        overlayChild: Stack(
          children: [
            Positioned(
              top: r.h(30),
              right: r.w(30),
              child: const SideControls(),
            ),

            Positioned(
              top: r.h(30),
              left: r.w(30),
              child: _buildLargeMicButton(r),
            ),

            Positioned(
              bottom: r.h(30),
              left: r.w(30),
              width: r.w(380),
              child: const NavigationPanel(),
            ),

            Positioned(
              bottom: r.h(30),
              right: r.w(30),
              width: r.w(380),
              child: const ArrivalPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeMicButton(ResponsiveLayout r) {
    return Container(
      padding: r.edgeInsetsAll(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(r.sp(12)),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(
        Icons.mic_none_outlined,
        color: Colors.white,
        size: r.iconXs,
      ),
    );
  }
}
