import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/glass_card.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(child: Column(), borderRadius: BorderRadius.circular(24));
  }
}