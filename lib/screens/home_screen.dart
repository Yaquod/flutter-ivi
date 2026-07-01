import 'package:flutter/material.dart';
import 'package:flutter_ivi/widgets/car_card.dart';
import 'package:flutter_ivi/features/map/map_card.dart';
import 'package:flutter_ivi/widgets/music_card.dart';
import 'package:flutter_ivi/widgets/weather_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onMapTap, this.onMusicTap});
  final VoidCallback onMapTap;
  final VoidCallback? onMusicTap;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 1, child: CarCard()),

              SizedBox(width: r.w(24)),

              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(flex: 5, child: MapCard(onTap: onMapTap)),

                    SizedBox(height: r.h(24)),

                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(child: WeatherCard()),

                          SizedBox(width: r.w(24)),

                          Expanded(flex: 2, child: MusicCard(onTap: onMusicTap)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
