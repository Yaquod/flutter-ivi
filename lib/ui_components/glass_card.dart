import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    required this.borderRadius,
    this.padding = EdgeInsets.zero,
  });
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: borderRadius,

    //     gradient: LinearGradient(
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //       colors: [Colors.white, Colors.transparent,Colors.transparent,Colors.white,],
    //       // stops: [0, 0.2,0.90, 1]
    //     ),
    //   ),

    //   padding: const EdgeInsets.all(1),

    //   child: ClipRRect(
    //     borderRadius: borderRadius,

    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: borderRadius,

    //           gradient: LinearGradient(
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //       colors: [Colors.white.withValues(alpha: 0.4), Colors.transparent],
    //     ),
    //         ),

    //         padding: padding,
    //         child: child,
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.4),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.4),
          ],

          stops:const [0, 0.15, 0.9, 1]
        ),
      ),

      padding: EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: borderRadius,

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),

            child: Stack(
              children: [
                _buildRadialGlow(
                  alignment: Alignment.topLeft,
                  color: Color(0xff0938df).withValues(alpha: 0.15),
                  borderRadius: borderRadius,
                ),

                _buildRadialGlow(
                  alignment: Alignment.bottomRight,
                  color: Color(0xff151515).withValues(alpha: 0.4),
                  borderRadius: borderRadius,
                ),

                Padding(padding: padding, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_buildRadialGlow({
  required Alignment alignment,
  required Color color,
  required BorderRadius borderRadius,
}) {
  return Positioned.fill(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,

        gradient: RadialGradient(
          center: alignment,
          radius: 1.2,
          colors: [color, Colors.transparent],
        ),
      ),
    ),
  );
}
