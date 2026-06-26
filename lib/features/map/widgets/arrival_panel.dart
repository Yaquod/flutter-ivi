import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:google_fonts/google_fonts.dart';

class ArrivalPanel extends StatelessWidget {
  const ArrivalPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

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
              _buildTextColumn(r, "Fireart Studio", "ul. Marynarska 21, 02-674", CrossAxisAlignment.start),
              _buildTextColumn(r, "09:51", "Estimated Arrival", CrossAxisAlignment.end),
            ],
          ),
          _buildProgressBar(r),
        ],
      ),
    );
  }

  Widget _buildTextColumn(ResponsiveLayout r, String title, String sub, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: r.sp(12), fontWeight: FontWeight.w700)),
        SizedBox(height: r.h(4)),
        Text(sub, style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: r.sp(8), fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildProgressBar(ResponsiveLayout r) {
    return Row(
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
    );
  }
}
