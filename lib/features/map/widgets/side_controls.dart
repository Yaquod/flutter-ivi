import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import '../logic/map_manager.dart';

class SideControls extends StatelessWidget {
  const SideControls({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Column(
      children: [
        _buildSideButton(r, Icons.near_me_outlined),
        SizedBox(height: r.h(16)),
        Container(
          padding: r.edgeInsetsAll(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(r.sp(12)),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => MapManager.mapState.setZoom(MapManager.mapState.zoom + 1),
                child: Icon(Icons.add, color: Colors.white, size: r.iconXs),
              ),
              SizedBox(height: r.h(16)),
              GestureDetector(
                onTap: () => MapManager.mapState.setZoom(MapManager.mapState.zoom - 1),
                child: Icon(Icons.remove, color: Colors.white, size: r.iconXs),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideButton(ResponsiveLayout r, IconData icon) {
    return Container(
      padding: r.edgeInsetsAll(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(r.sp(12)),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white, size: r.iconXs),
    );
  }
}
