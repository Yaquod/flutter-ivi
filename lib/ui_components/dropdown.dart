import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class IviDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const IviDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Container(
      height: r.h(36),
      padding: EdgeInsets.symmetric(horizontal: r.w(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r.radiusSm),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.6),
            size: r.sp(18),
          ),
          dropdownColor: const Color(0xFF0D1B3E),
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: r.sp(13),
            fontFamily: 'SF Pro Display',
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
