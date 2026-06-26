import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class DriverPassengerToggle extends StatelessWidget {
  final bool isDriver;
  final ValueChanged<bool> onChanged;

  const DriverPassengerToggle({
    required this.isDriver,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToggleButton(
            label: 'Driver',
            isActive: isDriver,
            onTap: () => onChanged(true),
            isLeft: true,
          ),
          ToggleButton(
            label: 'Passenger',
            isActive: !isDriver,
            onTap: () => onChanged(false),
            isLeft: false,
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isLeft;

  const ToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: r.w(160),
        height: r.h(60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft:     Radius.circular(isLeft ? r.sp(16) : 0),
            bottomLeft:  Radius.circular(isLeft ? r.sp(16) : 0),
            topRight:    Radius.circular(isLeft ? 0 : r.sp(16)),
            bottomRight: Radius.circular(isLeft ? 0 : r.sp(16)),
          ),
          color: isActive ? AppColor.action_color : Colors.transparent,
          border: isActive
              ? null
              : Border.all(
                  color: AppColor.card_border_second_dark.withOpacity(0.10),
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? AppColor.primary_text_dark
                  : AppColor.secondary_text_dark,
              fontSize: r.sp(16),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
