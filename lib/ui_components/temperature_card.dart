import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({super.key, required this.icon, required this.onTap});

  @override
  State<CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<CircleIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final size = r.w(50);

    final Color iconColor = AppColor.icon_dark_white;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [

                 GlassCard(
                  width: size,
                  height: size,
                  borderRadius: size / 2,
              ),

              if (_isHovered)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.action_color.withOpacity(0.15),
                  ),
                ),

              Center(child: Icon(widget.icon, color: iconColor, size: r.iconSm)),
            ],
          ),
        ),
      ),
    );
  }
}

class TempDisplay extends StatelessWidget {
  final double temperature;

  const TempDisplay({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Text(
      '${temperature.toStringAsFixed(1)}\u00b0',
      style: TextStyle(
        color: AppColor.primary_text_dark,
        fontSize: r.sp(32),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class TemperatureCard extends StatefulWidget {
  const TemperatureCard({super.key});

  @override
  State<TemperatureCard> createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  double _leftTemp = 20.5;
  double _rightTemp = 20.5;

  static const double _minTemp = 16.0;
  static const double _maxTemp = 32.0;
  static const double _step = 0.5;

  void _adjustTemp(bool isLeft, bool increment) {
    setState(() {
      if (isLeft) {
        _leftTemp = (_leftTemp + (increment ? _step : -_step)).clamp(
          _minTemp,
          _maxTemp,
        );
      } else {
        _rightTemp = (_rightTemp + (increment ? _step : -_step)).clamp(
          _minTemp,
          _maxTemp,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Container(
      height: r.h(80),
      width: r.w(650),
      padding: EdgeInsets.symmetric(horizontal: r.w(30)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(r.sp(57.5)),
          topRight: Radius.circular(r.sp(57.5)),
          bottomLeft: Radius.circular(r.sp(32)),
          bottomRight: Radius.circular(r.sp(32)),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.66],
          colors: [
            AppColor.card_first_dark.withOpacity(0.25),
            AppColor.card_second_dark.withOpacity(0.25),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: r.sp(8),
            offset: Offset(0, r.h(2)),
          ),
        ],

        border: Border.all(
          color: AppColor.action_color.withOpacity(0.2),
          width: 1.5,
        ),
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween , 
          children: [

            Expanded(
              flex : 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.remove,
                    onTap: () => _adjustTemp(true, false),
                  ),

                  TempDisplay(temperature: _leftTemp),

                  CircleIconButton(
                    icon: Icons.add,
                    onTap: () => _adjustTemp(true, true),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3 ,
              child: Icon(Icons.ac_unit, color: AppColor.action_color, size: r.iconMd)),

             Expanded(
                flex : 5,
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.remove,
                    onTap: () => _adjustTemp(false, false),
                  ),

                  TempDisplay(temperature: _rightTemp),

                  CircleIconButton(
                    icon: Icons.add,
                    onTap: () => _adjustTemp(false, true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
