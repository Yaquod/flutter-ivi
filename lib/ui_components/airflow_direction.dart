import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class AirflowButton extends StatefulWidget {
  final IconData icon;

  const AirflowButton({
    super.key,
    required this.icon,
  });

  @override
  State<AirflowButton> createState() => _AirflowButtonState();
}

class _AirflowButtonState extends State<AirflowButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    final Color iconColor =
        _isPressed ? AppColor.action_color : AppColor.icon_dark_gray;

    return GestureDetector(
      onTap: () => setState(() => _isPressed = !_isPressed),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: SizedBox(
          width: r.w(40),
          height: r.h(40),
          child: Stack(
            alignment: Alignment.center,
            children: [

              Icon(
                widget.icon,
                color: iconColor,
                  size: r.iconMd,
                ),

                if (_isHovered && !_isPressed)
                Icon(
                  widget.icon,
                  color: AppColor.neutral_500,
                  size: r.iconMd,
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class AirflowControl extends StatelessWidget {
  final String label;

  const AirflowControl({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return SizedBox(
      width: r.w(72),
      height: r.h(200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            label,
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: r.sp(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: r.h(8)),

          Container(
            width:  r.w(72),
            height: r.h(152),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.sp(16)),
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
            child: CustomPaint(
              painter: _SeatBorderPainter(radius: r.sp(16)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: r.h(22), horizontal: r.w(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AirflowButton(icon: Icons.arrow_upward),
                    AirflowButton(icon: Icons.arrow_downward),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class _SeatBorderPainter extends CustomPainter {
  final double radius;

  const _SeatBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = AppColor.card_border_second_dark.withOpacity(0.10),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end:   Alignment.bottomCenter,
          stops: const [0.0, 0.86],
          colors: [
            Colors.black.withOpacity(0.0),
            AppColor.action_color.withOpacity(0.30),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(_SeatBorderPainter old) => old.radius != radius;
}
