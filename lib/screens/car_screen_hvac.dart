import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/airflow_direction.dart';
import 'package:flutter_ivi/ui_components/buttons.dart';
import 'package:flutter_ivi/ui_components/fan.dart';
import 'package:flutter_ivi/ui_components/temperature_card.dart';

class HVACPage extends StatelessWidget {
  const HVACPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //car image
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 700,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    gradient: RadialGradient(
                      colors: [AppColor.neutral_100, Colors.transparent],
                      stops: [0.0, 0.6],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/car.png'),
                ),
              ],
            ),
          ),

          Expanded(
            //wrap left , right airflow and row
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Row(
                children: [
                  Expanded(flex: 1, child: AirflowControl(label: 'left')),

                  //  3 element wrapped in a colomn tempertaure card , 3 buttons , fan
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //temperature card
                        Expanded(flex: 5, child: TemperatureCard()),

                        Spacer(flex: 1),

                        //row for the 3 button
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Row(
                           
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'A/C', font_size: 30),
                                ),
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'Auto', font_size: 30),
                                ),
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'Sync', font_size: 30),
                                ),
                              ],
                            ),
                          ),
                        ),

                     
                        Spacer(flex: 1),

                        //fan
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: FanSpeedSelector(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(flex: 1, child: AirflowControl(label: 'right')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
