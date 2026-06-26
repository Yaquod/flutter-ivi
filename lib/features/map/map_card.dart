import 'package:flutter/material.dart';
import 'package:flutter_ivi/features/map/logic/map_manager.dart';
import 'package:flutter_ivi/features/map/widgets/base_mab.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
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
    final r = ResponsiveLayout.of(context);

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
                  top: r.h(15),
                  right: r.w(15),
                  child: _buildSideControlColumn(r),
                ),

                Positioned(
                  top: r.h(15),
                  left: r.w(15),
                  child: _buildSideButton(r, Icons.mic_none_outlined),
                ),

                Positioned(
                  bottom: r.h(15),
                  left: r.w(15),
                  width: r.w(280),
                  height: r.h(82),
                  child: _buildBlueNavigationPanel(r),
                ),

                Positioned(
                  bottom: r.h(15),
                  right: r.w(15),
                  width: r.w(280),
                  height: r.h(82),
                  child: _buildGreyArrivalPanel(r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideControlColumn(ResponsiveLayout r) {
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
                onTap: () {
                  MapManager.mapState.setZoom(MapManager.mapState.zoom + 1);
                },
                child: Icon(Icons.add, color: Colors.white, size: r.iconXs),
              ),
              SizedBox(height: r.h(16)),
              GestureDetector(
                onTap: () {
                  MapManager.mapState.setZoom(MapManager.mapState.zoom - 1);
                },
                child: Icon(Icons.remove, color: Colors.white, size: r.iconXs),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlueNavigationPanel(ResponsiveLayout r) {
    return Container(
      padding: r.edgeInsetsAll(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(r.sp(16)),
      ),
      child: Row(
        children: [
          Icon(Icons.turn_right_rounded, color: Colors.white, size: r.iconXl),
          SizedBox(width: r.w(24)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("500 m", style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(18), fontWeight: FontWeight.w700)),
                Text("Use the right lane for the main road", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: r.sp(11), fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyArrivalPanel(ResponsiveLayout r) {
    return Container(
      padding: r.edgeInsetsAll(12),
      decoration: BoxDecoration(
        color: const Color(0xff333333).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(r.sp(16)),
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
                  Text("Fireart Studio", style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(12), fontWeight: FontWeight.w700)),
                  SizedBox(height: r.h(4)),
                  Text("ul. Marynarska 21, 02-674", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: r.sp(8), fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("09:51", style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(12), fontWeight: FontWeight.w700)),
                  SizedBox(height: r.h(4)),
                  Text("Estimated Arrival", style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: r.sp(8), fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text("5.1 km", style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(15), fontWeight: FontWeight.w700)),
              SizedBox(width: r.w(15)),
              Expanded(
                child: Container(
                  height: r.h(3),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(r.sp(2))),
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    alignment: Alignment.centerLeft,
                    child: Container(decoration: BoxDecoration(color: const Color(0xFF00E5FF), borderRadius: BorderRadius.circular(r.sp(2)))),
                  ),
                ),
              ),
              SizedBox(width: r.w(15)),
              Text("9 min", style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(15), fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton(ResponsiveLayout r, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: r.edgeInsetsAll(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(r.sp(12)),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: r.iconXs),
      ),
    );
  }
}
