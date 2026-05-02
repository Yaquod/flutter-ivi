import 'package:flutter/material.dart';

class TrafficBulb extends StatelessWidget {
  final Color color;
  final bool active;
  const TrafficBulb({required this.color, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        // glow effect when active
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withOpacity(0.7),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // filled circle
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? color : color.withOpacity(0.15),
            ),
          ),

          // ring — only shows when active
          if (active)
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.8),
                  width: 2.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildTrafficLight(bool tlRed, bool tlYellow, bool tlGreen) {
  return Row(
    children: [
      TrafficBulb(color: const Color(0xFFB52323), active: tlRed),
      const SizedBox(width: 16),
      TrafficBulb(color: const Color(0xFFF3DB42), active: tlYellow),
      const SizedBox(width: 16),
      TrafficBulb(color: const Color(0xFF42F348), active: tlGreen),
    ],
  );
}