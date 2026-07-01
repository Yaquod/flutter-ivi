import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class SettingSoundScreen extends StatefulWidget {
  const SettingSoundScreen({super.key});

  @override
  State<SettingSoundScreen> createState() => SettingSoundScreenState();
}

class SettingSoundScreenState extends State<SettingSoundScreen> {
  double _mediaVolume = 0.65;
  double _navigationVolume = 0.75;
  double _alertVolume = 0.50;
  bool _bassBoost = false;
  bool _voiceClarity = false;
  String _equalizer = 'Flat';

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
                      title: 'Sound & Audio',
                      subtitle: 'Manage audio settings and preferences',
                    ),
                    SizedBox(height: r.h(48)),

                    // Media Volume slider
                    SliderSettingCard(
                      title: 'Media Volume',
                      subtitle: 'Music, videos, and games',
                      value: _mediaVolume,
                      onChanged: (v) => setState(() => _mediaVolume = v),
                    ),

                    // Dark Mode + Auto Brightness (same layout as display per design)
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
                                        title: 'Bass Boost',
                                        subtitle: 'Enhance audio playback',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    IviToggle(
                                      value: _bassBoost,
                                      onChanged: (v) =>
                                          setState(() => _bassBoost = v),
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
                                        title: 'Voice Clarity',
                                        subtitle:
                                            'clearer podcasts and dialogue',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    IviToggle(
                                      value: _voiceClarity,
                                      onChanged: (v) =>
                                          setState(() => _voiceClarity = v),
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
                // Navigation Volume
                SliderSettingCard(
                  title: 'Navigation Volume',
                  subtitle: 'GPS and directions',
                  value: _navigationVolume,
                  onChanged: (v) => setState(() => _navigationVolume = v),
                  h:200
                ),
                SizedBox(height: r.h(48)),

                // Alert Volume
                SliderSettingCard(
                  title: 'Alert Volume',
                  subtitle: 'Notifications and alerts',
                  value: _alertVolume,
                  onChanged: (v) => setState(() => _alertVolume = v),
                  h:200
                ),
                SizedBox(height: r.h(48)),

                // Equalizer dropdown
                DropdownSettingCard(
                  title: 'Equalizer',
                  subtitle: 'Customize audio profile',
                  value: _equalizer,
                  items: [
                    'Flat',
                    'Bass Boost',
                    'Treble Boost',
                    'Voice',
                    'Pop',
                    'Rock',
                    'Jazz',
                  ],
                  onChanged: (v) =>
                      setState(() => _equalizer = v ?? _equalizer),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
