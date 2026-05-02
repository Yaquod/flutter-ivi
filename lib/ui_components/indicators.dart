import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';

class TurnSignalIndicator extends StatefulWidget {
  final int turnSignal; // 0=none 1=left 2=right
  const TurnSignalIndicator({super.key, required this.turnSignal});

  @override
  State<TurnSignalIndicator> createState() => _TurnSignalIndicatorState();
}

class _TurnSignalIndicatorState extends State<TurnSignalIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Arrow(blink: _blink, active: widget.turnSignal == 1, left: true),
        _Arrow(blink: _blink, active: widget.turnSignal == 2, left: false),
      ],
    );
  }
}


class _Arrow extends StatelessWidget {
  final AnimationController blink;
  final bool active;
  final bool left;

  const _Arrow({required this.blink, required this.active, required this.left});

  @override
  Widget build(BuildContext context) {
    const blue = AppColor.action_color;

    return AnimatedBuilder(
      animation: blink,
      builder: (_, __) {
        final opacity = active ? (0.3 + 0.7 * blink.value) : 0.15;
        final color = blue.withOpacity(opacity);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            color: active ? blue.withOpacity(blink.value * 0.12) : Colors.transparent,
          ),
          child: Icon(
            left ? Icons.arrow_back_ios_new_sharp : Icons.arrow_forward_ios_sharp,
            color: color,
            size: 24,
          ),
        );
      },
    );
  }
}