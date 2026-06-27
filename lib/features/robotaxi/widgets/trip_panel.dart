import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/perception_models.dart';
import '../providers/autoware_state.dart';
import '../providers/trip_provider.dart';

class TripPanel extends StatelessWidget {
  const TripPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final auto = context.watch<AutowareState>();
    final trip = context.watch<TripProvider>();
    final eta = auto.cluster?.eta;
    final isRunning = auto.trip?.tripState == TripState.running;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PassengerProfile(name: trip.passengerName),
            const SizedBox(height: 24),
            _RideProgressSlider(fraction: auto.tripProgress),
            const SizedBox(height: 24),
            _EtaCard(
              remainingM: eta?.remainingDistanceM ?? 8400,
              remainingS: eta?.remainingTimeS ?? 1080,
            ),
            const SizedBox(height: 20),
            _PaymentSplitCard(fare: trip.fareUsd),
            const SizedBox(height: 28),
            _EndRideButton(enabled: isRunning),
          ],
        ),
      ),
    );
  }
}

class _PassengerProfile extends StatelessWidget {
  final String name;
  const _PassengerProfile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: Colors.white70, size: 28),
        ),
        const SizedBox(width: 14),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _RideProgressSlider extends StatelessWidget {
  final double fraction;
  const _RideProgressSlider({required this.fraction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF00d2ff)),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pickup',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
            Text('Destination',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

class _EtaCard extends StatelessWidget {
  final double remainingM;
  final double remainingS;
  const _EtaCard({required this.remainingM, required this.remainingS});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFF00d2ff), size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(remainingS / 60).round()} min',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Text(
                '${(remainingM / 1000).toStringAsFixed(1)} km remaining',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentSplitCard extends StatelessWidget {
  final double fare;
  const _PaymentSplitCard({required this.fare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Fare', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text(
                '\$${fare.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.people, size: 16),
              label: const Text('Split Fare'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndRideButton extends StatelessWidget {
  final bool enabled;
  const _EndRideButton({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00d2ff),
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(
          enabled ? 'End Ride' : 'Not Available',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
