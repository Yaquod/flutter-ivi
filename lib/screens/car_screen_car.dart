import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/tire_pressure.dart';
import 'dart:math' as math;

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          // ── Top section ──────────────────────────────────────
          Expanded(
            flex: 6,
            child: Row(
              children: [

                //left car info
                const Expanded(
                  flex: 4,
                  child: _CarInfoPanel(),
                ),

                // car with tire pressure 
                const Expanded(
                  flex: 6,
                  child: TirePressurePanel(),
                ),

              ],
            ),
          ),

          const SizedBox(height: 24),

          //circular progress 
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircularGauge(
                  value: 500,
                  max: 1000,
                  unit: 'Mi',
                  label: 'Fuel',
                ),
                const SizedBox(width: 40),
                _CircularGauge(
                  value: 5000,
                  max: 8000,
                  unit: '',
                  label: 'RPM',
                ),
                const SizedBox(width: 40),
                _CircularGauge(
                  value: 200,
                  max: 300,
                  unit: '',
                  label: 'KPH',
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

// car info pannel

class _CarInfoPanel extends StatelessWidget {
  const _CarInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          // car name 
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'HONDA CIVIC ',
                  style: TextStyle(
                    color: AppColor.primary_text_dark,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: '2025',
                  style: TextStyle(
                    color: AppColor.secondary_text_dark,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 4),
      
          // color
          const Text(
            'White Pearl',
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: 14,
            ),
          ),
      
          const SizedBox(height: 32),
      
          // battery level
          _InfoRow(
            icon: Icons.battery_charging_full,
            label: 'Battery Level',
            value: '75%',
            isHighlighted: true,
          ),
      
          const SizedBox(height: 16),
      
          // driving range
          _InfoRow(
            icon: Icons.directions_car,
            label: 'Driving Range',
            value: '306 Km',
          ),
      
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColor.secondary_text_dark, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColor.action_color.withOpacity(0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isHighlighted
                  ? AppColor.action_color
                  : AppColor.primary_text_dark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tire Pressure Panel ──────────────────────────────────────────────────────

class TirePressurePanel extends StatelessWidget {
  const TirePressurePanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        // ── Car top view image ────────────────────────────
        SizedBox(
          width: 280,
          height: 340,
          child: Image.asset(
            'assets/images/car_top_view.png',
            fit: BoxFit.contain,
          ),
        ),

        // ── Front left tire ───────────────────────────────
        Positioned(
          top: 20,
          left: 150,
          child: TirePressure(value: 34),
        ),

        // ── Front right tire ──────────────────────────────
        Positioned(
          top: 20,
          right: 150,
          child: TirePressure(value: 34),
        ),

        // ── Rear left tire ────────────────────────────────
        Positioned(
          bottom: 20,
          left: 150,
          child: TirePressure(value: 34),
        ),

        // ── Rear right tire ───────────────────────────────
        Positioned(
          bottom: 20,
          right: 150,
          child: TirePressure(value: 34),
        ),

      ],
    );
  }
}





// ─── Circular Gauge ───────────────────────────────────────────────────────────

class _CircularGauge extends StatelessWidget {
  final double value;
  final double max;
  final String unit;
  final String label;

  const _CircularGauge({
    required this.value,
    required this.max,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ── Gauge ─────────────────────────────────────────
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: _GaugePainter(value: value / max),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value.toInt().toString(),
                      style: const TextStyle(
                        color: AppColor.action_color,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: unit.isNotEmpty ? '\n$unit' : '',
                      style: const TextStyle(
                        color: AppColor.secondary_text_dark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

     //   const SizedBox(height: 8),

        // ── Label ─────────────────────────────────────────
        Text(
          label,
          style: const TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: 14,
          ),
        ),

      ],
    );
  }
}

// ─── Gauge Painter ────────────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0

  const _GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // ── Start: bottom-left, sweep ~270 degrees ──────────
    const startAngle = math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

    // ── Background track ─────────────────────────────────
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      Paint()
        ..color = const Color(0xFF1E2A3A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // ── Active arc ───────────────────────────────────────
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * value,
      false,
      Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepTotal,
          colors: [
            AppColor.action_color.withOpacity(0.60),
            AppColor.action_color,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}