import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/bottom_nav.dart';
import 'package:flutter_ivi/widgets/top_bar.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import 'package:flutter_ivi/screens/apps_screen.dart';
import 'package:flutter_ivi/screens/car_screen.dart';
import 'package:flutter_ivi/screens/home_screen.dart';
import 'package:flutter_ivi/screens/map_screen.dart';
import 'package:flutter_ivi/screens/setting_screen.dart';
import 'package:flutter_ivi/ui_components/app_background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    final List<Widget> pages = [
      HomeScreen(
        onMapTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      const CarScreen(),
      const MapScreen(),
      const AppsScreen(),
      const SettingScreen(),
    ];

    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: r.edgeInsetsAll(24),
          child: Column(
            children: [
              const TopBar(),

              SizedBox(height: r.h(24)),

              Expanded(
                child: IndexedStack(index: _currentIndex, children: pages),
              ),

              SizedBox(height: r.h(24)),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.w(220),
                  vertical: r.h(20),
                ),
                child: BottomNav(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
