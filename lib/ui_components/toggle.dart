import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class IviToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const IviToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? AppColor.action_color.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: value
                ? AppColor.action_color
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment:
                value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    value ? AppColor.action_color : Colors.white.withOpacity(0.5),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: AppColor.action_color.withOpacity(0.5),
                          blurRadius: 8,
                        )
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}