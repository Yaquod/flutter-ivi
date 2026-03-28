import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/bottom_nav.dart';
import 'package:flutter_ivi/widgets/top_bar.dart';
import 'package:flutter_ivi/screens/apps_screen.dart';
import 'package:flutter_ivi/screens/car_screen.dart';
import 'package:flutter_ivi/screens/home_screen.dart';
import 'package:flutter_ivi/screens/map_screen.dart';
import 'package:flutter_ivi/screens/settings_screen.dart';
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
      const SettingsScreen(),
    ];

    return Scaffold(
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const TopBar(),

              const SizedBox(height: 24),

              Expanded(
                child: IndexedStack(index: _currentIndex, children: pages),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 220,
                  vertical: 20,
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
