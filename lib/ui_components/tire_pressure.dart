import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';


class TirePressure extends StatelessWidget {
  final int value;

  const TirePressure({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

       //blue bar
       Stack(
        
        children: [

          Container(
          width: 80,
          height: 6,
          color: AppColor.card_second_dark.withOpacity(0.25),
          ),


          Container(
          width: 40,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
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
       

        const SizedBox(height: 4),

       //value
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: const TextStyle(
                  color: AppColor.primary_text_dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(
                text: ' Psi',
                style: TextStyle(
                  color: AppColor.secondary_text_dark,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}