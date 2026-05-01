import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class GearSelector extends StatelessWidget {
  final String activeLetter;

  const GearSelector({super.key, required this.activeLetter});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLetter('D'),
        const SizedBox(width: 50),
        _buildLetter('P'),
        const SizedBox(width: 50),
        _buildLetter('N'),
        const SizedBox(width: 50),
        _buildLetter('R'),
      ],
    );
  }

  Widget _buildLetter(String letter) {
    final bool isActive = activeLetter == letter;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      style: TextStyle(
        fontSize: isActive ? 42 : 36,
        fontWeight: FontWeight.bold,
        color: isActive ? AppColor.action_color : AppColor.card_first_dark,
        shadows: [
          Shadow(
            blurRadius: 4.0,
             color: Colors.black.withOpacity(0.6),
            offset: Offset(2, 2),
          ),

          if (isActive)
              Shadow(
              blurRadius: 10.0,
              color: Colors.blue,
              offset: Offset(0, 0),
            ),
        ],
      ),
      child: Text(letter),
    );
  }
}
