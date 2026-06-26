import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class FanSpeedBar extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onTap;

  const FanSpeedBar({
    super.key,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<FanSpeedBar> createState() => _FanSpeedBarState();
}

class _FanSpeedBarState extends State<FanSpeedBar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    final bool isPressed = widget.isActive;
    final bool isHovered = _isHovered && !isPressed;

    final borderColor = (isHovered || isPressed)
        ? AppColor.action_color
        : AppColor.card_border_second_dark.withOpacity(0.10);

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: r.w(100),
          height: r.h(60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.sp(8)),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(r.sp(7)),
            child: Stack(
              children: [

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end:   Alignment.bottomRight,
                        stops: const [0.0, 0.66],
                        colors: [
                          AppColor.card_first_dark.withOpacity(0.25),
                          AppColor.card_second_dark.withOpacity(0.25),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:  double.infinity,
                    height: isPressed ? r.h(60) : 0,
                    color:  AppColor.action_color,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FanSpeedSelector extends StatefulWidget {
  const FanSpeedSelector({super.key});

  @override
  State<FanSpeedSelector> createState() => _FanSpeedSelectorState();
}

class _FanSpeedSelectorState extends State<FanSpeedSelector> {
  int _selectedLevel = 0;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Fan Speed',
          style: TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: r.sp(14),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: r.h(6)),

        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final level = index + 1;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 4 ? r.w(8) : 0),
                  child: FanSpeedBar(
                    isActive: _selectedLevel >= level,
                    onTap: () => setState(() => _selectedLevel = level),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
