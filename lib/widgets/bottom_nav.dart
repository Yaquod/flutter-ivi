import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(Icons.home_filled, 0),
        _buildNavItem(Icons.directions_car_filled, 1),
        _buildNavItem(Icons.location_on, 2),
        _buildNavItem(Icons.apps_sharp, 3),
        _buildNavItem(Icons.settings_sharp, 4),

      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index){
  return GestureDetector(
    onTap: () => onTap(index),
    child: NavIcon(icon, currentIndex==index),
  );
}
}



class NavIcon extends StatelessWidget {
  const NavIcon(this.icon, this.active, {super.key});
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Color(0xff429DF3);
    final Color inactiveColor = Color(0xff666666);

    return Icon(
      icon,
      color: active ? activeColor : inactiveColor,
      size: 40,

      shadows:active ? [
        Shadow(
          color: activeColor.withValues(alpha: 0.8),
          blurRadius: 3,
          offset: Offset(0, 0)
        ),

        Shadow(
          color: activeColor.withValues(alpha: 0.4),
          blurRadius: 6,
          offset: Offset(0, 0)
        ),
      ] : null,
    );
  }
}
