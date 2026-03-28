import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArrivalPanel extends StatelessWidget {
  final double scale;

  const ArrivalPanel({super.key, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: const Color(0xff333333).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTextColumn("Fireart Studio", "ul. Marynarska 21, 02-674", CrossAxisAlignment.start),
              _buildTextColumn("09:51", "Estimated Arrival", CrossAxisAlignment.end),
            ],
          ),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildTextColumn(String title, String sub, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 12 * scale, fontWeight: FontWeight.w700)),
        SizedBox(height: 4 * scale),
        Text(sub, style: GoogleFonts.inter(color: const Color(0xffcccccc), fontSize: 8 * scale, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Text("5.1 km", style: GoogleFonts.inter(color: Colors.white, fontSize: 15 * scale, fontWeight: FontWeight.w700)),
        SizedBox(width: 15 * scale),
        Expanded(
          child: Container(
            height: 3 * scale,
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            child: FractionallySizedBox(
              widthFactor: 0.6,
              alignment: Alignment.centerLeft,
              child: Container(decoration: BoxDecoration(color: const Color(0xFF00E5FF), borderRadius: BorderRadius.circular(2))),
            ),
          ),
        ),
        SizedBox(width: 15 * scale),
        Text("9 min", style: GoogleFonts.inter(color: Colors.white, fontSize: 15 * scale, fontWeight: FontWeight.w700)),
      ],
    );
  }
}