import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_slider.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

// ─── Title + subtitle label for setting rows ────────────────────────────────
class SettingLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  final MainAxisAlignment mainAxisAlignment;

  const SettingLabel({
    super.key,
    required this.title,
    required this.subtitle,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,

      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(r.sp(0), r.sp(0), r.sp(0), r.sp(0)),
          child: Text(
            title,
            style: TextStyle(
              fontSize: r.sp(32),
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: r.h(4)),
        Padding(
          padding: EdgeInsets.fromLTRB(r.sp(0), r.sp(0), r.sp(0), r.sp(0)),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: r.sp(20),
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.45),
            ),
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
  final double h;

  const SliderSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.h = 230,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GlassCard(
      width: r.w(700),
      height: r.h(h),
      //  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.sp(48), r.sp(32), r.sp(48), r.sp(0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingLabel(title: title, subtitle: subtitle),
            SizedBox(height: r.h(24)),
            IviSlider(value: value, onChanged: onChanged, min: min, max: max),
          ],
        ),
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
          Expanded(
            child: SettingLabel(title: title, subtitle: subtitle),
          ),
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
    final r = ResponsiveLayout.of(context);
    return GlassCard(
      width: r.w(700),
      height: r.h(200),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.sp(48), r.sp(0), r.sp(48), r.sp(0)),
        child: Row(
          children: [
            Expanded(
              child: SettingLabel(title: title, subtitle: subtitle),
            ),
            IviDropdown(value: value, items: items, onChanged: onChanged),
          ],
        ),
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
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }
}
