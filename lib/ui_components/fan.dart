
import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';

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

  static const double widthBar  = 100.0;
  static const double heightBar = 60.0;
   static const double radiusBar = 8.0;

  @override
  Widget build(BuildContext context) {

    


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
          width: widthBar,
          height:heightBar,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusBar),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radiusBar - 1),
            child: Stack(
              children: [

                // ── Layer 1: gradient background default state ──────────────────
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

                // ── Layer 2: blue fill rising from bottom pressed state─────────
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width:  double.infinity,
                    height: isPressed ? heightBar: 0,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Fan Speed',
          style: const TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),

        Expanded(

          child: Row(
            children: List.generate(5, (index) {
              final level = index + 1;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 4 ? 8 : 0),
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


