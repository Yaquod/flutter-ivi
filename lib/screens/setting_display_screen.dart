import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class SettingDisplayScreen extends StatefulWidget {
  const SettingDisplayScreen({super.key});

  @override
  State<SettingDisplayScreen> createState() => SettingDisplayScreenState();
}

class SettingDisplayScreenState extends State<SettingDisplayScreen> {
  double _brightness = 0.6;
  bool _darkMode = false;
  bool _autoBrightness = false;
  bool _alwaysShowClock = true;
  String _screenTimeout = '30 seconds';
  int _selectedThemeColor = 0;

  final List<Color> _themeColors = [
    const Color(0xff34C759),
    const Color(0xFFAC7F5E),
    AppColor.action_color,
    const Color(0xff00C8B3),
  ];

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
            padding:  EdgeInsets.fromLTRB(r.sp(32), r.sp(15), r.sp(0), r.sp(0)),
            child: GlassCard(
              width: r.w(500),
              height: r.h(800),
              child: Padding(
                padding: EdgeInsets.all(r.w(48)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingSectionHeader(
                      title: 'Display Settings',
                      subtitle: 'Customize your display preferences',
                    ),
                    SizedBox(height: r.h(48)),
            
                    // Brightness slider
                    SliderSettingCard(
                      title: 'Brightness',
                      subtitle: 'Adjust screen brightness',
                      value: _brightness,
                      onChanged: (v) => setState(() => _brightness = v),
                    ),
            
                    
                    
            
                    // Dark Mode + Auto Brightness side by side
                    Padding(
                      padding:  EdgeInsets.fromLTRB(r.sp(0), r.sp(48), r.sp(0), r.sp(0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              width: r.w(200) , 
                              height: r.h(230),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(r.sp(32), r.sp(32), r.sp(0), r.sp(32)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SettingLabel(
                                        title: 'Dark Mode',
                                        subtitle: 'Use dark theme',
                                        mainAxisAlignment: MainAxisAlignment.start,
                                      ),
                                    ),
                                  
                                      IviToggle(
                                        value: _darkMode,
                                        onChanged: (v) => setState(() => _darkMode = v),
                                      ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: r.w(32)),
                          Expanded(
                            child: GlassCard(
                             width: r.w(200) , 
                              height: r.h(230),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(r.sp(32), r.sp(32), r.sp(0), r.sp(32)),
                                child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SettingLabel(
                                        title: 'Auto Brightness',
                                        subtitle: 'Adjust based on ambient light',
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                  // Always Show Clock
                  GlassCard(
                    width: r.w(700) , 
                    height: r.h(200),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(r.sp(48), r.sp(0), r.sp(48), r.sp(0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: SettingLabel(
                              title: 'Always Show Clock',
                              subtitle: 'Display time when screen is off',
                            ),
                          ),
                          IviToggle(
                            value: _alwaysShowClock,
                            onChanged: (v) =>
                                setState(() => _alwaysShowClock = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: r.h(48)),

                  // Theme Color
                  GlassCard(
                     width: r.w(700) , 
                    height: r.h(200),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(r.sp(48), r.sp(0), r.sp(48), r.sp(0)),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SettingLabel(
                              title: 'Theme Color',
                              subtitle: 'Choose accent color',
                            ),
                          ),
                          
                          Row(
                            children: List.generate(
                              _themeColors.length,
                              (i) => GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedThemeColor = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.only(right: r.w(12)),
                                  width: r.sp(32),
                                  height: r.sp(32),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _themeColors[i],
                                    border: _selectedThemeColor == i
                                        ? Border.all(
                                            color: Colors.white,
                                            width: r.sp(2.5),
                                          )
                                        : null,
                                    boxShadow: _selectedThemeColor == i
                                        ? [
                                            BoxShadow(
                                              color: _themeColors[i].withOpacity(
                                                0.6,
                                              ),
                                              blurRadius: r.sp(10),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: r.h(48)),

                  // Screen Timeout
                  DropdownSettingCard(
                    title: 'Screen Timeout',
                    subtitle: 'Turn off screen after inactivity',
                    value: _screenTimeout,
                    items: [
                      '15 seconds',
                      '30 seconds',
                      '1 minute',
                      '2 minutes',
                      'Never',
                    ],
                    onChanged: (v) =>
                        setState(() => _screenTimeout = v ?? _screenTimeout),
                  ),
                ],
              ),
            ),
          ),
        
      ],
    );
  }
}
