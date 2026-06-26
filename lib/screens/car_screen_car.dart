import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/tire_pressure.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'dart:math' as math;

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Padding(
      padding: r.edgeInsetsAll(24),
      child: Column(
        children: [

          Expanded(
            flex: 6,
            child: Row(
              children: [

                const Expanded(
                  flex: 4,
                  child: _CarInfoPanel(),
                ),

                const Expanded(
                  flex: 6,
                  child: TirePressurePanel(),
                ),

              ],
            ),
          ),

          SizedBox(height: r.h(24)),

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
                SizedBox(width: r.w(40)),
                _CircularGauge(
                  value: 5000,
                  max: 8000,
                  unit: '',
                  label: 'RPM',
                ),
                SizedBox(width: r.w(40)),
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

class _CarInfoPanel extends StatelessWidget {
  const _CarInfoPanel();

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Padding(
      padding: r.edgeInsetsAll(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'HONDA CIVIC ',
                  style: TextStyle(
                    color: AppColor.primary_text_dark,
                    fontSize: r.sp(28),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: '2025',
                  style: TextStyle(
                    color: AppColor.secondary_text_dark,
                    fontSize: r.sp(28),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: r.h(4)),

          Text(
            'White Pearl',
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: r.sp(14),
            ),
          ),

          SizedBox(height: r.h(32)),

          _InfoRow(
            icon: Icons.battery_charging_full,
            label: 'Battery Level',
            value: '75%',
            isHighlighted: true,
          ),

          SizedBox(height: r.h(16)),

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
    final r = ResponsiveLayout.of(context);

    return Row(
      children: [
        Icon(icon, color: AppColor.secondary_text_dark, size: r.iconXs),
        SizedBox(width: r.w(8)),
        Text(
          label,
          style: TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: r.sp(14),
          ),
        ),
        SizedBox(width: r.w(12)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: r.w(10), vertical: r.h(3)),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColor.action_color.withOpacity(0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(r.sp(8)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isHighlighted
                  ? AppColor.action_color
                  : AppColor.primary_text_dark,
              fontSize: r.sp(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class TirePressurePanel extends StatelessWidget {
  const TirePressurePanel();

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [

        SizedBox(
          width: r.w(280),
          height: r.h(340),
          child: Image.asset(
            'assets/images/car_top_view.png',
            fit: BoxFit.contain,
          ),
        ),

        Positioned(
          top: r.h(20),
          left: r.w(150),
          child: TirePressure(value: 34),
        ),

        Positioned(
          top: r.h(20),
          right: r.w(150),
          child: TirePressure(value: 34),
        ),

        Positioned(
          bottom: r.h(20),
          left: r.w(150),
          child: TirePressure(value: 34),
        ),

        Positioned(
          bottom: r.h(20),
          right: r.w(150),
          child: TirePressure(value: 34),
        ),

      ],
    );
  }
}

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
    final r = ResponsiveLayout.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        SizedBox(
          width: r.w(140),
          height: r.h(140),
          child: CustomPaint(
            painter: _GaugePainter(value: value / max),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value.toInt().toString(),
                      style: TextStyle(
                        color: AppColor.action_color,
                        fontSize: r.sp(26),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: unit.isNotEmpty ? '\n$unit' : '',
                      style: TextStyle(
                        color: AppColor.secondary_text_dark,
                        fontSize: r.sp(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Text(
          label,
          style: TextStyle(
            color: AppColor.secondary_text_dark,
            fontSize: r.sp(14),
          ),
        ),

      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;

  const _GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    const startAngle = math.pi * 0.75;
    const sweepTotal = math.pi * 1.5;

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
