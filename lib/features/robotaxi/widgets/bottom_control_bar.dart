import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomControlBar extends StatelessWidget {
  const BottomControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = DateFormat('HH:mm').format(now);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0f1422),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          _MediaBlock(),
          const Spacer(),
          Text(
            timeStr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          _ClimateBlock(),
        ],
      ),
    );
  }
}

class _MediaBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous_rounded,
              color: Colors.white70, size: 20),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow_rounded,
              color: Colors.white, size: 24),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.skip_next_rounded,
              color: Colors.white70, size: 20),
          onPressed: () {},
        ),
        const SizedBox(width: 12),
        Text(
          'Lo-Fi Beats',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
      ],
    );
  }
}

class _ClimateBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ClimateChip(icon: Icons.ac_unit_rounded, label: '68°F'),
        const SizedBox(width: 8),
        _ClimateChip(icon: Icons.air_rounded, label: 'Auto'),
        const SizedBox(width: 8),
        _ClimateChip(
            icon: Icons.airline_seat_recline_normal_rounded, label: 'Seat'),
      ],
    );
  }
}

class _ClimateChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ClimateChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF00d2ff), size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
