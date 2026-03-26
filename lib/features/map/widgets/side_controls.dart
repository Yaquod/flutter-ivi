import 'package:flutter/material.dart';
import '../logic/map_manager.dart';

class SideControls extends StatelessWidget {
  final double scale; // معامل تكبير الحجم (1.0 للطبيعي)

  const SideControls({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSideButton(Icons.near_me_outlined),
        SizedBox(height: 16 * scale),
        Container(
          padding: EdgeInsets.all(8 * scale),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12 * scale),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => MapManager.mapState.setZoom(MapManager.mapState.zoom + 1),
                child: Icon(Icons.add, color: Colors.white, size: 18 * scale),
              ),
              SizedBox(height: 16 * scale),
              GestureDetector(
                onTap: () => MapManager.mapState.setZoom(MapManager.mapState.zoom - 1),
                child: Icon(Icons.remove, color: Colors.white, size: 18 * scale),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8 * scale),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white, size: 18 * scale),
    );
  }
}