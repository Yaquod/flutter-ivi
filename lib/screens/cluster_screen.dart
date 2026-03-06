import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../proto/vehicle_frame.pb.dart';
import 'dart:math' as math;

class ClusterScreen extends StatelessWidget {
  const ClusterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<VehicleFrameNotifier>();
    final frame = notifier.latest;

    if (notifier.error != null) {
      return _ErrorView(message: notifier.error!);
    }
    if (frame == null) {
      return const _LoadingView();
    }
    return _ClusterView(frame: frame);
  }
}

// ── Loading ──────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48, height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF00E5FF),
              ),
            ),
            SizedBox(height: 20),
            Text('CONNECTING', style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 11,
              letterSpacing: 4,
              fontFamily: 'monospace',
            )),
          ],
        ),
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_off, color: Color(0xFFFF3D57), size: 40),
            const SizedBox(height: 16),
            const Text('CONNECTION LOST', style: TextStyle(
              color: Color(0xFFFF3D57),
              fontSize: 11,
              letterSpacing: 4,
              fontFamily: 'monospace',
            )),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(
              color: Color(0x66FFFFFF),
              fontSize: 11,
              fontFamily: 'monospace',
            ), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Main cluster view ─────────────────────────────────────────────────────────

class _ClusterView extends StatelessWidget {
  final VehicleFrame frame;
  const _ClusterView({required this.frame});

  @override
  Widget build(BuildContext context) {
    final speed = frame.velocity.speedKmh;
    final gear = _gearLabel(frame.gear.value);
    final mode = frame.controlMode.name.replaceFirst('MODE_', '');
    final battery = frame.batteryPct;
    final isMrm = frame.mrm.isActive;
    final turnSignal = frame.turnSignal.value; // 0=none 1=left 2=right

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            _TopBar(mode: mode, isMrm: isMrm, seq: frame.seq.toInt()),
            const SizedBox(height: 8),

            // ── Speedometer ──
            Expanded(
              flex: 5,
              child: _Speedometer(speed: speed, turnSignal: turnSignal),
            ),

            // ── Info row ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _InfoRow(frame: frame, gear: gear, battery: battery),
            ),
            const SizedBox(height: 12),

            // ── Bottom strip ──
            _BottomStrip(frame: frame),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _gearLabel(int v) {
    switch (v) {
      case 1: return 'P';
      case 2: return 'R';
      case 3: return 'N';
      case 4: return 'D';
      default: return '—';
    }
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String mode;
  final bool isMrm;
  final int seq;
  const _TopBar({required this.mode, required this.isMrm, required this.seq});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // Mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: mode == 'AUTO'
                  ? const Color(0xFF00E5FF)
                  : const Color(0xFF666680), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(mode, style: TextStyle(
              color: mode == 'AUTO' ? const Color(0xFF00E5FF) : const Color(0xFF888899),
              fontSize: 11,
              letterSpacing: 3,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            )),
          ),
          const Spacer(),
          // MRM warning
          if (isMrm)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x33FF3D57),
                border: Border.all(color: const Color(0xFFFF3D57), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('⚠ MRM ACTIVE', style: TextStyle(
                color: Color(0xFFFF3D57),
                fontSize: 11,
                letterSpacing: 2,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700,
              )),
            ),
          const Spacer(),
          // Frame counter
          Text('# ${seq.toString().padLeft(6, '0')}', style: const TextStyle(
            color: Color(0x44FFFFFF),
            fontSize: 10,
            letterSpacing: 1,
            fontFamily: 'monospace',
          )),
        ],
      ),
    );
  }
}

// ── Speedometer ───────────────────────────────────────────────────────────────

class _Speedometer extends StatelessWidget {
  final double speed;
  final int turnSignal;
  const _Speedometer({required this.speed, required this.turnSignal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.85;
      return Stack(
        alignment: Alignment.center,
        children: [
          // Arc painter
          SizedBox(
            width: size, height: size,
            child: CustomPaint(painter: _ArcPainter(speed: speed, maxSpeed: 180)),
          ),
          // Speed number
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text(
                speed.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'monospace',
                  height: 1,
                ),
              ),
              const Text('km/h', style: TextStyle(
                color: Color(0x88FFFFFF),
                fontSize: 13,
                letterSpacing: 3,
                fontFamily: 'monospace',
              )),
              const SizedBox(height: 8),
              // Turn signal indicators
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios, size: 16,
                      color: turnSignal == 1 ? const Color(0xFF00FF88) : const Color(0x22FFFFFF)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16,
                      color: turnSignal == 2 ? const Color(0xFF00FF88) : const Color(0x22FFFFFF)),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ArcPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  const _ArcPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false,
      Paint()
        ..color = const Color(0x22FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Fill
    final fill = (speed / maxSpeed).clamp(0.0, 1.0);
    if (fill > 0) {
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle * fill,
        colors: const [Color(0xFF00E5FF), Color(0xFF00FF88)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle * fill, false,
        Paint()
          ..shader = gradient
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }

    // Tick marks
    for (int i = 0; i <= 9; i++) {
      final angle = startAngle + sweepAngle * (i / 9);
      final isMajor = i % 3 == 0;
      final outer = center + Offset(math.cos(angle), math.sin(angle)) * (radius - 10);
      final inner = center + Offset(math.cos(angle), math.sin(angle)) * (radius - (isMajor ? 22 : 16));
      canvas.drawLine(outer, inner, Paint()
        ..color = isMajor ? const Color(0x88FFFFFF) : const Color(0x33FFFFFF)
        ..strokeWidth = isMajor ? 2 : 1);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.speed != speed;
}

// ── Info row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final VehicleFrame frame;
  final String gear;
  final double battery;
  const _InfoRow({required this.frame, required this.gear, required this.battery});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _InfoTile(label: 'GEAR', value: gear, accent: const Color(0xFF00E5FF)),
        _InfoTile(label: 'BATTERY', value: '${(battery * 100).toStringAsFixed(0)}%',
            accent: battery < 0.2 ? const Color(0xFFFF3D57) : const Color(0xFF00FF88)),
        _InfoTile(label: 'OBJECTS', value: '${frame.surroundObjects.length}',
            accent: const Color(0xFFFFB800)),
        _InfoTile(label: 'ETA', value: '${frame.eta.remainingTimeS.toStringAsFixed(0)}s',
            accent: const Color(0xFF00E5FF)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  const _InfoTile({required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(
          color: accent,
          fontSize: 22,
          fontWeight: FontWeight.w300,
          fontFamily: 'monospace',
        )),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(
          color: Color(0x55FFFFFF),
          fontSize: 9,
          letterSpacing: 2,
          fontFamily: 'monospace',
        )),
      ],
    );
  }
}

// ── Bottom strip ──────────────────────────────────────────────────────────────

class _BottomStrip extends StatelessWidget {
  final VehicleFrame frame;
  const _BottomStrip({required this.frame});

  @override
  Widget build(BuildContext context) {
    final hasRed = frame.adas.trafficLightRed;
    final hasGreen = frame.adas.trafficLightGreen;
    final hasYellow = frame.adas.trafficLightYellow;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x15FFFFFF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Speed limit
          _Strip(label: 'LIMIT',
              value: '${(frame.speedLimitMps * 3.6).toStringAsFixed(0)} km/h'),
          // Target speed
          _Strip(label: 'TARGET',
              value: '${(frame.targetSpeedMps * 3.6).toStringAsFixed(0)} km/h'),
          // Traffic lights
          Row(children: [
            _TrafficDot(color: const Color(0xFFFF3D57), active: hasRed),
            const SizedBox(width: 4),
            _TrafficDot(color: const Color(0xFFFFB800), active: hasYellow),
            const SizedBox(width: 4),
            _TrafficDot(color: const Color(0xFF00FF88), active: hasGreen),
          ]),
          // Distance
          _Strip(label: 'DIST',
              value: '${(frame.eta.remainingDistanceM / 1000).toStringAsFixed(2)} km'),
        ],
      ),
    );
  }
}

class _Strip extends StatelessWidget {
  final String label;
  final String value;
  const _Strip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w400,
        )),
        Text(label, style: const TextStyle(
          color: Color(0x44FFFFFF),
          fontSize: 8,
          letterSpacing: 2,
          fontFamily: 'monospace',
        )),
      ],
    );
  }
}

class _TrafficDot extends StatelessWidget {
  final Color color;
  final bool active;
  const _TrafficDot({required this.color, required this.active});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : color.withOpacity(0.15),
        boxShadow: active ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)] : null,
      ),
    );
  }
}