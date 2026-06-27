import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';

class SettingConnectivityScreen extends StatefulWidget {
  const SettingConnectivityScreen({super.key});

  @override
  State<SettingConnectivityScreen> createState() =>
      SettingConnectivityScreenState();
}

class SettingConnectivityScreenState
    extends State<SettingConnectivityScreen> {
  double _mediaVolume = 0.5;
  bool _darkMode = false;
  bool _autoBrightness = false;
  double _navigationVolume = 0.6;
  double _alertVolume = 0.4;
  String _equalizer = 'Flat';

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
                    title: 'Connectivity',
                    subtitle: 'Manage wireless connections',
                  ),
                  const SizedBox(height: 24),

                  // Media Volume slider
                  SliderSettingCard(
                    title: 'Media Volume',
                    subtitle: 'Music, videos, and games',
                    value: _mediaVolume,
                    onChanged: (v) => setState(() => _mediaVolume = v),
                  ),
                  const SizedBox(height: 16),

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
                                  title: 'Dark Mode',
                                  subtitle: 'Use dark theme',
                                ),
                              ),
                              IviToggle(
                                value: _darkMode,
                                onChanged: (v) =>
                                    setState(() => _darkMode = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassCard(
                          width: double.infinity,
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: SettingLabel(
                                  title: 'Auto Brightness',
                                  subtitle: 'Adjust based on ambient light',
                                ),
                              ),
                              IviToggle(
                                value: _autoBrightness,
                                onChanged: (v) =>
                                    setState(() => _autoBrightness = v),
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
                  SliderSettingCard(
                    title: 'Navigation Volume',
                    subtitle: 'GPS and directions',
                    value: _navigationVolume,
                    onChanged: (v) =>
                        setState(() => _navigationVolume = v),
                  ),
                  const SizedBox(height: 20),

                  SliderSettingCard(
                    title: 'Alert Volume',
                    subtitle: 'Notifications and alerts',
                    value: _alertVolume,
                    onChanged: (v) => setState(() => _alertVolume = v),
                  ),
                  const SizedBox(height: 20),

                  DropdownSettingCard(
                    title: 'Equalizer',
                    subtitle: 'Customize audio profile',
                    value: _equalizer,
                    items: ['Flat', 'Bass Boost', 'Treble Boost', 'Voice'],
                    onChanged: (v) =>
                        setState(() => _equalizer = v ?? _equalizer),
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