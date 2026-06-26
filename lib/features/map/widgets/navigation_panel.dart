import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationPanel extends StatelessWidget {
  const NavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

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
                Text("500 m", 
                  style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(18), fontWeight: FontWeight.w700)),
                Text("Use the right lane for the main road", 
                  style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: r.sp(11), fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
