import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/airflow_direction.dart';
import 'package:flutter_ivi/ui_components/buttons.dart';
import 'package:flutter_ivi/ui_components/fan.dart';
import 'package:flutter_ivi/ui_components/temperature_card.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class HVACPage extends StatelessWidget {
  const HVACPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Container(
      child: Column(
        children: [
          //car image
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: r.w(700),
                  height: r.h(200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(r.w(300)),
                    gradient: RadialGradient(
                      colors: [AppColor.neutral_100, Colors.transparent],
                      stops: [0.0, 0.6],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: r.h(10)),
                  child: Image.asset('assets/images/car.png'),
                ),
              ],
            ),
          ),

          Expanded(
            //wrap left , right airflow and row
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r.w(80)),
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
                            padding: EdgeInsets.symmetric(horizontal: r.w(60)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'A/C', font_size: r.sp(30)),
                                ),
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'Auto', font_size: r.sp(30)),
                                ),
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 2,
                                  child: Button(label: 'Sync', font_size: r.sp(30)),
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
                            padding: EdgeInsets.symmetric(horizontal: r.w(40)),
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
