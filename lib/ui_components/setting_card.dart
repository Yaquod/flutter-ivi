import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';

/// A dark inner card used inside the main GlassCard for each setting row.
class SettingCard extends StatelessWidget {
  final Widget child;
  final double height;
  //final EdgeInsets padding;

  const SettingCard({
    super.key,
    required this.child,
   required this.height,
  //  this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {

    return GlassCard(
      width: double.infinity,
      height: height,
    );
    // return Container(
    //   height: height,
    //   width: double.infinity,
    //  // padding: padding,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(16),
    //     color: Colors.white.withOpacity(0.05),
    //     border: Border.all(
    //       color: Colors.white.withOpacity(0.08),
    //       width: 1,
    //     ),
    //   ),
    //   child: child,
    // );
  }
}