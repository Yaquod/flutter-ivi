import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';



class DoorRect extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const DoorRect({required this.isSelected, required this.onTap});

  @override
  State<DoorRect> createState() => _DoorRectState();
}

class _DoorRectState extends State<DoorRect> {
   bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
     final isActive = widget.isSelected || _isHovered;
     return MouseRegion(
     onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
     
    child:GestureDetector(
      onTap: widget.onTap,
      
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width:  90,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.isSelected
              ? AppColor.action_color.withOpacity(0.25)
              : AppColor.card_second_dark.withOpacity(0.1),
          border: Border.all(
            color: isActive
                ? AppColor.action_color
                : AppColor.card_border_second_dark.withOpacity(0.20),
            width: 1.5,
          ),
        ),
      ),
    )
     );
  }
}

