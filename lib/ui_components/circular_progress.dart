import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class CircularProgress extends StatefulWidget {
  final double Val;
  final int percent;

  const CircularProgress({
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
    final r = ResponsiveLayout.of(context);

    return Container(
     width: r.w(120),
     height: r.h(120),
      child: Stack(
          alignment: Alignment.center,
          children: [

            SizedBox(
              width: r.w(120),
              height: r.h(120),
              child: CircularProgressIndicator(
                value: widget.Val,
                strokeWidth: r.w(10),
                backgroundColor: AppColor.card_second_dark.withOpacity(.25),
                valueColor: AlwaysStoppedAnimation(AppColor.action_color),
              ),
            ),

            Text(
              '${widget.percent}%',
              style: TextStyle(
                color: AppColor.action_color,
                fontSize: r.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }
}
