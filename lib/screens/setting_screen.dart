import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/menu_selector.dart';
import 'package:flutter_ivi/screens/setting_display_screen.dart';
import 'package:flutter_ivi/screens/setting_sound_screen.dart';
import 'package:flutter_ivi/screens/setting_connectivity_screen.dart';
import 'package:flutter_ivi/screens/setting_system_screen.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Display',
    'Sound',
    'Connectivity',
    'System',
  ];

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.w(24), vertical: r.h(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Side Menu ─────────────────────────────────────────────────
          SideMenu(
            items: _menuItems,
            selectedIndex: _selectedIndex,
            onChanged: (index) => setState(() => _selectedIndex = index),
          ),

          SizedBox(width: r.w(24)),

          // ── Content area with IndexedStack ────────────────────────────
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                SettingDisplayScreen(),
                SettingSoundScreen(),
                SettingConnectivityScreen(),
                SettingSystemScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
