import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_slider.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';

// ─── Title + subtitle label for setting rows ────────────────────────────────
class SettingLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const SettingLabel({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.45),
          ),
        ),
      ],
    );
  }
}

// ─── Slider row card ─────────────────────────────────────────────────────────
class SliderSettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const SliderSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 80,
    //  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingLabel(title: title, subtitle: subtitle),
          const SizedBox(height: 8),
          IviSlider(value: value, onChanged: onChanged, min: min, max: max),
        ],
      ),
    );
  }
}

// ─── Toggle row card ─────────────────────────────────────────────────────────
class ToggleSettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          Expanded(child: SettingLabel(title: title, subtitle: subtitle)),
          IviToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ─── Dropdown row card ───────────────────────────────────────────────────────
class DropdownSettingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          Expanded(child: SettingLabel(title: title, subtitle: subtitle)),
          IviDropdown(value: value, items: items, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ─── Section title + subtitle heading ────────────────────────────────────────
class SettingSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SettingSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}