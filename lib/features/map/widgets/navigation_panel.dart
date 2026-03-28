import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationPanel extends StatelessWidget {
  final double scale;

  const NavigationPanel({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Row(
        children: [
          Icon(Icons.turn_right_rounded, color: Colors.white, size: 60 * scale),
          SizedBox(width: 24 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("500 m", 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 18 * scale, fontWeight: FontWeight.w700)),
                Text("Use the right lane for the main road", 
                  style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: 11 * scale, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}