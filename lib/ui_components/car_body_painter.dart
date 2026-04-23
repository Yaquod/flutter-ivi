import 'package:flutter/material.dart';



class CarBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..color = const Color(0xFF1A2940).withOpacity(0.80)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF429DF3).withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // final windowPaint = Paint()
    //   ..color = const Color(0xFF429DF3).withOpacity(0.10)
    //   ..style = PaintingStyle.fill;

    // final windowBorderPaint = Paint()
    //   ..color = const Color(0xFF429DF3).withOpacity(0.20)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;

    // ── Main car body ───────────────────────────────────
    final bodyPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.05, w * 0.80, h * 0.90),
        const Radius.circular(40),
      ));
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, borderPaint);

    // ── Front bumper ────────────────────────────────────
    final frontBumper = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.02, w * 0.60, h * 0.05),
      const Radius.circular(12),
    );
    canvas.drawRRect(frontBumper, bodyPaint);
    canvas.drawRRect(frontBumper, borderPaint);

    // ── Rear bumper ─────────────────────────────────────
    final rearBumper = RRect.fromRectAndRadius(

      Rect.fromLTWH(w * 0.20, h * 0.93, w * 0.60, h * 0.05),
      const Radius.circular(12),
    );
    canvas.drawRRect(rearBumper, bodyPaint);
    canvas.drawRRect(rearBumper, borderPaint);

    // ── Left mirror ─────────────────────────────────────
    // final leftMirror = RRect.fromRectAndRadius(
    //   Rect.fromLTWH(w * 0.01, h * 0.20, w * 0.09, h * 0.07),
    //   const Radius.circular(8),
    // );
    // canvas.drawRRect(leftMirror, bodyPaint);
    // canvas.drawRRect(leftMirror, borderPaint);

    // // ── Right mirror ─────────────────────────────────────
    // final rightMirror = RRect.fromRectAndRadius(
    //   Rect.fromLTWH(w * 0.90, h * 0.20, w * 0.09, h * 0.07),
    //   const Radius.circular(8),
    // );
    // canvas.drawRRect(rightMirror, bodyPaint);
    // canvas.drawRRect(rightMirror, borderPaint);

    // ── Windshield (front) ──────────────────────────────
    // final frontWindshield = RRect.fromRectAndRadius(
    //   Rect.fromLTWH(w * 0.15, h * 0.08, w * 0.70, h * 0.12),
    //   const Radius.circular(10),
    // );
    // canvas.drawRRect(frontWindshield, windowPaint);
    // canvas.drawRRect(frontWindshield, windowBorderPaint);

    // ── Rear windshield ─────────────────────────────────
    // final rearWindshield = RRect.fromRectAndRadius(
    //   Rect.fromLTWH(w * 0.15, h * 0.80, w * 0.70, h * 0.10),
    //   const Radius.circular(10),
    // );
    // canvas.drawRRect(rearWindshield, windowPaint);
    // canvas.drawRRect(rearWindshield, windowBorderPaint);

    // ── Wheel arches ─────────────────────────────────────
    // final wheelPaint = Paint()
    //   ..color = const Color(0xFF0D1520)
    //   ..style = PaintingStyle.fill;

    // final wheelBorderPaint = Paint()
    //   ..color = const Color(0xFF429DF3).withOpacity(0.30)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;

  
  }

  @override
  bool shouldRepaint(CarBodyPainter old) => false;
}