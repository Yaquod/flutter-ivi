import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/setting_widget.dart';
import 'package:flutter_ivi/ui_components/toggle.dart';
import 'package:flutter_ivi/ui_components/dropdown.dart';
import 'package:flutter_ivi/ui_components/setting_card.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left panel ─────────────────────────────────────────────────
        Expanded(
          flex: 1,
          child: GlassCard(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingSectionHeader(
                    title: 'Display Settings',
                    subtitle: 'Customize your display preferences',
                  ),
                  const SizedBox(height: 24),

                  // Brightness slider
                  SliderSettingCard(
                    title: 'Brightness',
                    subtitle: 'Adjust screen brightness',
                    value: _brightness,
                    onChanged: (v) => setState(() => _brightness = v),
                  ),



                  //brightness slider
                  // GlassCard(
                  // width: double.infinity, 
                  // height: 50
                  
                  
                  // ),
                  const SizedBox(height: 16),

                  // Dark Mode + Auto Brightness side by side
                  Row(
                    children: [
                      Expanded(
                        child: GlassCard(
                          width: double.infinity,
                          height: 150,
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
          flex: 1,
          child: GlassCard(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Always Show Clock
                  GlassCard(
                    width: double.infinity,
                    height: 80,
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
                  const SizedBox(height: 20),

                  // Theme Color
                  GlassCard(
                    width: double.infinity,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingLabel(
                          title: 'Theme Color',
                          subtitle: 'Choose accent color',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: List.generate(
                            _themeColors.length,
                            (i) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedThemeColor = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _themeColors[i],
                                  border: _selectedThemeColor == i
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: _selectedThemeColor == i
                                      ? [
                                          BoxShadow(
                                            color: _themeColors[i]
                                                .withOpacity(0.6),
                                            blurRadius: 10,
                                          )
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
                  const SizedBox(height: 20),

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
        ),
      ],
    );
  }
}