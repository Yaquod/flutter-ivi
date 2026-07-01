import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

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
    final r = ResponsiveLayout.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: r.sp(52),
        height: r.sp(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r.sp(14)),
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
          padding: EdgeInsets.all(r.sp(3)),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: r.sp(20),
              height: r.sp(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppColor.action_color : Colors.white.withOpacity(0.5),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: AppColor.action_color.withOpacity(0.5),
                          blurRadius: r.sp(8),
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
