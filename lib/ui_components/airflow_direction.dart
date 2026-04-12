import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';



// ─── Seat Icon Button (3 variants) ───────────────────────────────────────────

class SeatIconButton extends StatefulWidget {
  final String assetPath;

  const SeatIconButton({
    super.key,
    required this.assetPath,
  });

  @override
  State<SeatIconButton> createState() => _SeatIconButtonState();
}

class _SeatIconButtonState extends State<SeatIconButton> {
  bool _isHovered  = false;
  bool _isPressed  = false;

  static const double iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final double responsiveSize = screenWidth * (iconSize / 1280);

    // ── Derive color from state ─────────────────────────────
    final Color iconColor = _isPressed
        ? AppColor.action_color
        : AppColor.icon_dark_gray;

    return GestureDetector(
      onTap: () => setState(() => _isPressed = !_isPressed),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() {
          _isHovered = false;
        }),
        child: Stack(
          alignment: Alignment.center,
          children: [

            // ── Icon ───────────────────────────────────────
            SvgPicture.asset(
              widget.assetPath,
              width:  responsiveSize,
              height: responsiveSize,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),

            // ── Hover overlay: white 20% on top ────────────
            if (_isHovered && !_isPressed)
              Container(
                width:  responsiveSize,
                height: responsiveSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  shape: BoxShape.circle,
                ),
              ),

          ],
        ),
      ),
    );
  }
}


// ─── Seat Control Container ───────────────────────────────────────────────────

class SeatControl extends StatelessWidget {
  final String label; // 'Left' or 'Right'

  const SeatControl({
    super.key,
    required this.label,
  });

  // Base Figma size
  static const double baseWidth     = 72.0;
  static const double baseHeight    = 178.0;
  static const double baseRadius    = 16.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ── Responsive sizing ───────────────────────────────────
    final double width  = screenWidth  * (baseWidth  / 1280);
    final double height = screenHeight * (baseHeight / 900);
    final double radius = width * (baseRadius / baseWidth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ── Label ───────────────────────────────────────────
        Text(
          label,
          style: TextStyle(
            color: AppColor.primary_text_dark,
            fontSize: screenWidth * 0.011,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.008),

        // ── Container ───────────────────────────────────────
        Container(
          width:  width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            // ── Base fill: same as fan bar ──────────────────
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
            painter: _SeatBorderPainter(radius: radius),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SeatIconButton(assetPath: 'assets/icons/airflow_up.svg'),
                  SeatIconButton(assetPath: 'assets/icons/airflow_down.svg'),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


// ─── Custom Painter: two strokes ─────────────────────────────────────────────
// Stroke 1 — base: card_border_second_dark at 10% opacity
// Stroke 2 — linear on top: black transparent 0% → action_color at 86% stop, 30% opacity

class _SeatBorderPainter extends CustomPainter {
  final double radius;

  const _SeatBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );

    // ── Stroke 1: base border ───────────────────────────────
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = AppColor.card_border_second_dark.withOpacity(0.10);

    canvas.drawRRect(rrect, basePaint);

    // ── Stroke 2: linear gradient border on top ─────────────
    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end:   Alignment.bottomCenter,
        stops: const [0.0, 0.86],
        colors: [
          Colors.black.withOpacity(0.0),       // 0%  — transparent
          AppColor.action_color.withOpacity(0.30), // 86% — action color 30%
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRRect(rrect, gradientPaint);
  }

  @override
  bool shouldRepaint(_SeatBorderPainter old) => old.radius != radius;
}

