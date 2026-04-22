import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';




class CircularProgress extends StatefulWidget {
  final double Val;
  final int percent;

  const CircularProgress(
    {
      super.key,
     required this.Val,
     required this.percent,

    });

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
     width: 120,
     height: 120,
      child: Stack(
          alignment: Alignment.center,
          children: [

            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: widget.Val,
                strokeWidth: 10,
                backgroundColor: AppColor.card_second_dark.withOpacity(.25),
                valueColor: AlwaysStoppedAnimation(AppColor.action_color),
              ),
            ),

            
            Text(
              '${widget.percent}%',
              style: const TextStyle(
                color: AppColor.action_color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }
}