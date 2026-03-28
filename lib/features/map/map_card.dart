import 'package:flutter/material.dart';
import 'package:flutter_ivi/features/map/logic/map_manager.dart';
import 'package:flutter_ivi/features/map/widgets/base_mab.dart';
import 'package:google_fonts/google_fonts.dart';

class MapCard extends StatefulWidget {
  const MapCard({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque, 
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: const BaseMab(),
            ),
          ),

          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: 15,
                  right: 15,
                  child: _buildSideControlColumn(),
                ),

                Positioned(
                  top: 15,
                  left: 15,
                  child: _buildSideButton(Icons.mic_none_outlined),
                ),

                Positioned(
                  bottom: 15,
                  left: 15,
                  width: 280,
                  height: 82,
                  child: _buildBlueNavigationPanel(),
                ),

                Positioned(
                  bottom: 15,
                  right: 15,
                  width: 280,
                  height: 82,
                  child: _buildGreyArrivalPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSideControlColumn() {
    return Column(
      children: [
        _buildSideButton(Icons.near_me_outlined),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  MapManager.mapState.setZoom(MapManager.mapState.zoom + 1);
                },
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  MapManager.mapState.setZoom(MapManager.mapState.zoom - 1);
                },
                child: const Icon(Icons.remove, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlueNavigationPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.turn_right_rounded, color: Colors.white, size: 60),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("500 m", style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                Text("Use the right lane for the main road", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: 11, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyArrivalPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff333333).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fireart Studio", style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text("ul. Marynarska 21, 02-674", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: 8, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("09:51", style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text("Estimated Arrival", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: 8, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text("5.1 km", style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    alignment: Alignment.centerLeft,
                    child: Container(decoration: BoxDecoration(color: const Color(0xFF00E5FF), borderRadius: BorderRadius.circular(2))),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text("9 min", style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}