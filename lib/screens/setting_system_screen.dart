import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';

class SettingSystemScreen extends StatefulWidget {
  const SettingSystemScreen({super.key});

  @override
  State<SettingSystemScreen> createState() => SettingSystemScreenState();
}

class SettingSystemScreenState extends State<SettingSystemScreen> {
  double _softwareSlider = 1.0; // fully updated
  bool _autoUpdates = false;
  bool _locationServices = false;
  String _timeFormat = '12-hour';
  String _language = 'English';
  String _units = 'Metric';

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left panel ─────────────────────────────────────────────────
        Expanded(
          flex: 55,
          child: GlassCard(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingSectionHeader(
                    title: 'System',
                    subtitle: 'System preferences and updates',
                  ),
                  const SizedBox(height: 24),

                  // Software Version slider (read-only / version indicator)
                  GlassCard(
                    width: double.infinity,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingLabel(
                          title: 'Software Version',
                          subtitle: 'v2025.12.1 - Up to date',
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            activeTrackColor:
                                const Color(0xFF4CAF50).withOpacity(0.8),
                            inactiveTrackColor:
                                Colors.white.withOpacity(0.15),
                            thumbColor: const Color(0xFF4CAF50),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16),
                            overlayColor:
                                const Color(0xFF4CAF50).withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _softwareSlider,
                            onChanged: null, // read-only
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Auto Updates + Location Services
                  Row(
                    children: [
                      Expanded(
                        child: GlassCard(
                          width: double.infinity,
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: SettingLabel(
                                  title: 'Auto Updates',
                                  subtitle: 'Install updates automatically',
                                ),
                              ),
                              IviToggle(
                                value: _autoUpdates,
                                onChanged: (v) =>
                                    setState(() => _autoUpdates = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child:  GlassCard (
                          width: double.infinity,
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: SettingLabel(
                                  title: 'Location Services',
                                  subtitle: 'Allow apps to use location',
                                ),
                              ),
                              IviToggle(
                                value: _locationServices,
                                onChanged: (v) =>
                                    setState(() => _locationServices = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // ── Right panel ─────────────────────────────────────────────────
        Expanded(
          flex: 45,
          child: GlassCard(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Format
                  DropdownSettingCard(
                    title: 'Time Format',
                    subtitle: '12 or 24 hour format',
                    value: _timeFormat,
                    items: ['12-hour', '24-hour'],
                    onChanged: (v) =>
                        setState(() => _timeFormat = v ?? _timeFormat),
                  ),
                  const SizedBox(height: 20),

                  // Language
                  DropdownSettingCard(
                    title: 'Language',
                    subtitle: 'System language',
                    value: _language,
                    items: [
                      'English',
                      'Arabic',
                      'French',
                      'German',
                      'Spanish',
                      'Chinese',
                      'Japanese',
                    ],
                    onChanged: (v) =>
                        setState(() => _language = v ?? _language),
                  ),
                  const SizedBox(height: 20),

                  // Units
                  DropdownSettingCard(
                    title: 'Units',
                    subtitle: 'Distance and temperature units',
                    value: _units,
                    items: ['Metric', 'Imperial'],
                    onChanged: (v) => setState(() => _units = v ?? _units),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}