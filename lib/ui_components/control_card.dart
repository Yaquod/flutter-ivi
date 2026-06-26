import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/arrow_button.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class ControlCard extends StatefulWidget {
  final String label;
  final String unit;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double>? onChanged;
  final double initial_val;

  const ControlCard({
   super.key,
   required this.label,
   required this.unit,
   required this.max ,
   required this.min ,
   required this.initial_val,
   required this.step,
   this.onChanged, 
  });

  @override
  State<ControlCard> createState() => _ControlCardState();
}

class _ControlCardState extends State<ControlCard> {
  late double value;

  @override
   void initState() {
    super.initState();
    value = widget.initial_val;
  }

  @override
void didUpdateWidget(covariant ControlCard oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.initial_val != widget.initial_val) {
    setState(() {
      value = widget.initial_val;
    });
  }
}

  void increase() {
    setState(() {
      value = (value + widget.step).clamp(widget.min, widget.max);
        widget.onChanged?.call(value); 
    });
  }

  void decrease() {
    setState(() {
      value = (value - widget.step).clamp(widget.min, widget.max);
            widget.onChanged?.call(value); 
    });
  }

  double get progress =>
      (value - widget.min) / (widget.max - widget.min);

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GlassCard(
    width: r.w(328), 
    height: r.h(226),
    child : Padding(
      padding: EdgeInsets.symmetric(
        vertical: r.h(16),
        horizontal: r.w(24), 
      ),
      child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           Text(
                widget.label,
                style:TextStyle(
                  color : AppColor.secondary_text_dark,
                  fontSize: r.sp(16),
                ),
              ),

            Text(
                "${value.toStringAsFixed(0)} ${widget.unit}",
                style: TextStyle(
                  color: AppColor.action_color,
                  fontSize: r.sp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),

               Spacer(flex: 1),

              ClipRRect(
                borderRadius: BorderRadius.circular(r.sp(4)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: r.h(6),
                  backgroundColor: AppColor.card_border_first_dark.withOpacity(0.5),
                  valueColor:
                      AlwaysStoppedAnimation(AppColor.action_color),
                ),
              ),

            Spacer(flex: 1),

           Expanded(
            flex:5,
             child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ArrowButton(icon: Icons.keyboard_arrow_up, onTap: increase, borderRadius: r.sp(8)),
                    ),

                    SizedBox(width: r.w(30)),

                     Expanded(
                        child: ArrowButton(icon: Icons.keyboard_arrow_down, onTap: decrease, borderRadius: r.sp(8)),
                     ),

                  ],
             ),
           ),

          ],
      ) ,
    )
    ); 
  }
}
