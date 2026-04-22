import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget? child;

  const GlassCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _GlassCardPainter(borderRadius: borderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),

              // ── Fill: white linear gradient 20% opacity ────
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
                stops: const [0.0, 1.0],
                colors: [
                  const Color(0xFFFFFFFF).withOpacity(0.20 * 0.40), // 0%  stop → 40% of 20%
                  const Color(0xFFFFFFFF).withOpacity(0.0),          // 100% stop → 0%
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─── Custom Painter: 3 radial gradient strokes ────────────────────────────────

class _GlassCardPainter extends CustomPainter {
  final double borderRadius;

  const _GlassCardPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(borderRadius),
    );

   
    // ── Stroke 1: #0938DF radial, 50% opacity top left ──────────────
     _drawGradientStroke(
      canvas: canvas,
      rrect: rrect,
      rect: rect,
      globalOpacity:0.2,
      center:Alignment(-0.8, -0.8),
      radius: 1.2,
      color: Color(0xFF0938DF),
      opacity :1.0,

    );

     // ── Stroke 2: #0938DF radial, 50% opacity bottom right  ──────────────
     _drawGradientStroke(
      canvas: canvas,
      rrect: rrect,
      rect: rect,
      globalOpacity:0.2,
      center:Alignment(0.8, 0.8),
      radius: 1.2,
      color: Color(0xFF0938DF),
      opacity :1.0,

    );

    // ── Stroke 3: #FFFFFF radial, 80% opacity top left ──────────────
     _drawGradientStroke(
      canvas: canvas,
      rrect: rrect,
      rect: rect,
      globalOpacity:0.2,
      center:Alignment(-0.8, -0.8),
      radius: 1.2,
      color: Color(0xFFFFFFFF),
      opacity :1.0,

    );


     // ── Stroke 4: #FFFFFF radial, 80% opacity  bottom right ──────────────
     _drawGradientStroke(
      canvas: canvas,
      rrect: rrect,
      rect: rect,
      globalOpacity:0.2,
      center:Alignment(0.8, 0.8),
      radius: 1.2,
      color: Color(0xFFFFFFFF),
      opacity :1.0,

    );
    
  }

  @override
  bool shouldRepaint(_GlassCardPainter old) => old.borderRadius != borderRadius;
}


void _drawGradientStroke({
  required Canvas canvas,
  required RRect rrect,
  required Rect rect,
  required Alignment center,
  required double radius,
  required Color color,
  required double opacity,
  required double globalOpacity , 
  double strokeWidth = 1.0,
}) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = Colors.white.withOpacity(globalOpacity)
    ..shader = RadialGradient(
      center: center,
      radius: radius,
      stops: const [0.0, 1.0],
      colors: [
        color.withOpacity(opacity),
        color.withOpacity(0.0),
      ],
    ).createShader(rect);

  canvas.drawRRect(rrect, paint);
}