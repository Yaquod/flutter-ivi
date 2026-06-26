import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class SideMenu extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final double? width;
  final double? itemHeight;
  final double? height;

  const SideMenu({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.width,
    this.itemHeight,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GlassCard(
      width: width ?? r.w(212),
      height: height ?? r.h(448),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: r.h(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isSelected = index == selectedIndex;

            return Column(
              children: [
                GestureDetector(
                  onTap: () => onChanged(index),
                  child: AnimatedContainer(
                    height: itemHeight ?? r.h(80),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(r.sp(16)),
                      color: isSelected
                          ? AppColor.action_color.withOpacity(0.25)
                          : Colors.transparent,
                      border: isSelected
                          ? Border.all(
                              color: AppColor.action_color,
                              width: 1,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: r.sp(20),
                        color: isSelected
                            ? AppColor.action_color
                            : AppColor.secondary_text_dark,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      child: Text(items[index]),
                    ),
                  ),
                ),

                if (index != items.length - 1)
                  SizedBox(height: r.h(16)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
