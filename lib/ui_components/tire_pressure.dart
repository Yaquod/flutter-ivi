import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class TirePressure extends StatelessWidget {
  final int value;

  const TirePressure({required this.value});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

       Stack(
        children: [

          Container(
          width: r.w(80),
          height: r.h(6),
          color: AppColor.card_second_dark.withOpacity(0.25),
          ),

          Container(
          width: r.w(40),
          height: r.h(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.sp(3)),
            gradient: LinearGradient(
              colors: [
                AppColor.action_color,
                AppColor.action_color.withOpacity(0.30),
              ],
            ),
          ),
        ),
        ],
       ),

        SizedBox(height: r.h(4)),

        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: TextStyle(
                  color: AppColor.primary_text_dark,
                  fontSize: r.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' Psi',
                style: TextStyle(
                  color: AppColor.secondary_text_dark,
                  fontSize: r.sp(11),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
