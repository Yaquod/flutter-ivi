import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class IviSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const IviSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        activeTrackColor: AppColor.action_color,
        inactiveTrackColor: Colors.white.withOpacity(0.15),
        thumbColor: AppColor.action_color,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        overlayColor: AppColor.action_color.withOpacity(0.2),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}