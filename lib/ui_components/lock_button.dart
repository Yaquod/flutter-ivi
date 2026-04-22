
import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';


class LockIconButton extends StatefulWidget {
  final bool isLocked;
  final VoidCallback onTap;

  const LockIconButton({required this.isLocked, required this.onTap});

  @override
  State<LockIconButton> createState() => LockIconButtonState();
}

class LockIconButtonState extends State<LockIconButton> {
  bool _isHovered = false;


  @override
  Widget build(BuildContext context) {


     //icon color
    final Color iconColor = widget.isLocked
        ? AppColor.action_color      //pressed
        : AppColor.icon_dark_gray;   //default
    return GestureDetector(
       onTap: widget.onTap,

      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),

        child: 
        
             Stack(
            alignment: Alignment.center,
            children: [
              
              //default state
              GlassCard(width: 48, height: 48 , borderRadius: 48),

              //icon
              Icon(
                widget.isLocked ? Icons.lock : Icons.lock_open,
                color: iconColor,
                size: 22,
              ),

              // hover state
              if (_isHovered || widget.isLocked)
                Container(
                  width:  48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                     color : AppColor.action_color,
                     width: 1,
                    ),
                    
                  ),
                ),

               

               //pressed state
                if(widget.isLocked)
                Container(
                  width:  48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.action_color.withOpacity(0.1),
                    boxShadow: [BoxShadow(
                      color: AppColor.action_color.withOpacity(.5),
                      offset: Offset(0, 0),
                      blurRadius: 4,
                       spreadRadius: 2,
                    )
                    ]
                    
                  ),
                ),





            ],
          ),
              )
          
         
        
      
    );
  }
}
