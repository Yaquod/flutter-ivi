import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class SettingConnectivityScreen extends StatefulWidget {
  const SettingConnectivityScreen({super.key});

  @override
  State<SettingConnectivityScreen> createState() =>
      SettingConnectivityScreenState();
}

class SettingConnectivityScreenState extends State<SettingConnectivityScreen> {
  double _dataSync = 0.5;
  bool _wifi = false;
  bool _autoConnect = false;
  double _hotspotData = 0.6;
  double _hotspotTimeout = 0.4;
  String _hotspotBand = '2.4 GHz';

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
                      title: 'Connectivity',
                      subtitle: 'Manage wireless connections',
                    ),
                    SizedBox(height: r.h(48)),

                    // Media Volume slider
                    SliderSettingCard(
                      title: 'Data Sync Interval',
                      subtitle: 'Adjust cloud sync rate',
                      value: _dataSync,
                      onChanged: (v) => setState(() => _dataSync = v),
                    ),

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
                                        title: 'Wi-Fi Hotspot',
                                        subtitle: 'Share car internet',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    IviToggle(
                                      value: _wifi ,
                                      onChanged: (v) =>
                                          setState(() => _wifi = v),
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
                                        title: 'Auto-Connect',
                                        subtitle:
                                            'Pair phone on start',
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    IviToggle(
                                      value: _autoConnect,
                                      onChanged: (v) =>
                                          setState(() => _autoConnect = v),
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
                SliderSettingCard(
                  title: 'Hotspot Data Limit',
                  subtitle: 'Set monthly GB cap',
                  value: _hotspotData ,
                  onChanged: (v) => setState(() => _hotspotData = v),
                  h:200
                ),
                      SizedBox(height: r.h(48)),

                SliderSettingCard(
                  title: 'Hotspot Timeout',
                  subtitle: 'Auto-off when idle',
                  value:_hotspotTimeout,
                  onChanged: (v) => setState(() => _hotspotTimeout = v),
                  h:200
                ),
               SizedBox(height: r.h(48)),

                DropdownSettingCard(
                  title: 'Hotspot Band',
                  subtitle: 'Select Wi-Fi frequency',
                  value: _hotspotBand,
                  items: ['2.4 GHz','5.0 GHz', 'Auto'],
                  onChanged: (v) =>
                      setState(() => _hotspotBand = v ?? _hotspotBand),
                    
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
