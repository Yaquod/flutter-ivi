import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

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
    final r = ResponsiveLayout.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left panel ─────────────────────────────────────────────────
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.sp(32), r.sp(15), r.sp(0), r.sp(0)),

            child: GlassCard(
              width: r.w(500),
              height: r.h(800),
              child: Padding(
                padding: EdgeInsets.all(r.w(48)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingSectionHeader(
                      title: 'System',
                      subtitle: 'System preferences and updates',
                    ),
                    SizedBox(height: r.h(48)),

                    // Software Version slider (read-only / version indicator)
                    SliderSettingCard(
                      title: 'Software Version',
                      subtitle: 'v2025.12.1 - Up to date',
                      value: _softwareSlider,
                      onChanged: (v) => setState(() => _softwareSlider = v),
                    ),

                    // Auto Updates + Location Services
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        r.sp(0),
                        r.sp(48),
                        r.sp(0),
                        r.sp(0),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              width: r.w(200),
                              height: r.h(230),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  r.sp(32),
                                  r.sp(32),
                                  r.sp(0),
                                  r.sp(32),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SettingLabel(
                                        title: 'Auto Updates',
                                        subtitle:
                                            'Install updates automatically',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                          ),
                          SizedBox(width: r.w(32)),
                          Expanded(
                            child: GlassCard(
                              width: r.w(200),
                              height: r.h(230),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  r.sp(32),
                                  r.sp(32),
                                  r.sp(0),
                                  r.sp(32),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SettingLabel(
                                        title: 'Location Services',
                                        subtitle: 'Allow apps to use location',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: r.w(48)),

        // ── Right panel ─────────────────────────────────────────────────
        Expanded(
          flex: 1,

          child: Padding(
            padding: EdgeInsets.fromLTRB(r.sp(48), r.sp(40), r.sp(48), r.sp(0)),

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
                SizedBox(height: r.h(48)),

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
                  onChanged: (v) => setState(() => _language = v ?? _language),
                ),
               SizedBox(height: r.h(48)),

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
      ],
    );
  }
}
