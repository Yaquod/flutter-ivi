import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class ArrowButton extends StatefulWidget {
 final VoidCallback onTap;
 final IconData icon;
 final double borderRadius;

 const ArrowButton({
   super.key,
   required this.icon,
   required this.onTap,
   required this.borderRadius,
 });

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  bool _isHovered = false ; 

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return MouseRegion(
     onEnter: (_) =>  setState(() => _isHovered  = true),
     onExit: (_) => setState(() => _isHovered = false),
     child: GestureDetector(
      onTap: widget.onTap,
      child : Stack(
        alignment: Alignment.center,
        children: [
       GlassCard(width: r.w(124), height: r.h(50), borderRadius : widget.borderRadius),

       if(_isHovered)
        Container(
           width: r.w(124),
           height: r.h(50),
           decoration: BoxDecoration(
            color : AppColor.action_color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color : AppColor.action_color,
              width: 1.0,
            )
           ),
        ),

       Icon(
        widget.icon,
        color: AppColor.icon_dark_white,
        ),
        ],
      ),
     ),
    );
  }
}
