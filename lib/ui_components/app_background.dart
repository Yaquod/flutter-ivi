import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              colors: [
                Color(0xff1A1A1A),
                Color(0xff031A30),
                Color(0xff063460),
                Color(0xff031A30),
                Color(0xff1A1A1A),
              ],
            ),
          ),
        ),

        Positioned.fill(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}
