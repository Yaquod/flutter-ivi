import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';
import 'package:flutter_ivi/ui_components/gear_selector.dart';
import 'package:flutter_ivi/ui_components/traffic_lights.dart';
import 'package:flutter_ivi/ui_components/indicators.dart';
import 'package:flutter_ivi/ui_components/navigation_message.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../proto/vehicle_frame.pb.dart';
import '../widgets/responsive_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ClusterScreen extends StatelessWidget {
  const ClusterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<VehicleFrameNotifier>();
    final frame = notifier.latest;

    if (notifier.error != null) {
      return _ErrorView(message: notifier.error!);
    }
    if (frame == null) {
      return const _LoadingView();
    }
    return ClusterView(frame: frame);
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: r.sp(48),
              height: r.sp(48),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF00E5FF),
              ),
            ),
            SizedBox(height: r.h(20)),
            Text(
              'CONNECTING',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: r.fontXs,
                letterSpacing: 4,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link_off, color: Color(0xFFFF3D57), size: r.sp(40)),
            SizedBox(height: r.h(16)),
            Text(
              'CONNECTION LOST',
              style: TextStyle(
                color: Color(0xFFFF3D57),
                fontSize: r.fontXs,
                letterSpacing: 4,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(height: r.h(8)),
            Text(
              message,
              style: TextStyle(
                color: Color(0x66FFFFFF),
                fontSize: r.fontXs,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main cluster view ─────────────────────────────────────────────────────────

class ClusterView extends StatelessWidget {
  final VehicleFrame frame;
  const ClusterView({required this.frame});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Stack(
          children: [
            //blue light
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/blue_light.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //road
            Positioned(
              top: r.h(300),
              left: 0,
              right: 0,
              child: Image.asset('assets/images/road.png', fit: BoxFit.cover),
            ),

            //top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopBar(gear: 'D', hazard: true),
            ),

            //left , right indicators
            Positioned(
              top: r.h(60),
              left: r.w(350),
              right: r.w(350),
              child: TurnSignalIndicator(turnSignal: 2),
            ),

            //navigation message
            Positioned(
              top: r.h(140),
              left: 0,
              right: 0,
              child: Center(
                child: NavMessage(
                  turnDirection: 1,
                  distanceM: 500,
                ),
              ),
            ),

            //speed
            Positioned(
              top: r.h(140),
              left: r.w(120),
              child: build_display(r, 127, 'KM/H'),
            ),

            //energy
            Positioned(
              top: r.h(140),
              right: r.w(120),
              child: build_display(r, 3.4, 'KM/H'),
            ),

            //middle car
            Positioned(
              bottom: r.h(120),
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/car_middle.png',
                  width: r.w(160),
                  height: r.h(130),
                ),
              ),
            ),

            //truck
            Positioned(
              bottom: r.h(240),
              right: r.w(260),
              child: Image.asset(
                'assets/images/truck.png',
                width: r.w(200),
                height: r.h(160),
              ),
            ),

            //left car
            Positioned(
              bottom: r.h(240),
              left: r.w(300),
              child: Image.asset(
                'assets/images/left_car.png',
                width: r.w(154),
                height: r.h(90),
              ),
            ),

            //left card information
            Positioned(
              left: r.w(24),
              bottom: r.h(100),
              child: LeftCardInfo(
                acc: 4.03,
                max_speed: 80,
                target_speed: 100,
                yaw_rate: 20.3,
              ),
            ),

            //right card information
            Positioned(
              right: r.w(24),
              bottom: r.h(100),
              child: RightCarfIngo(
                eta_distance: 300,
                eta_time: 200,
                mrm: 'Normal',
                odometer: 25.00,
              ),
            ),

            //bottom bar
            Positioned(
              bottom: r.h(16),
              left: r.w(24),
              right: r.w(24),
              child: Center(
                child: BottomBar(
                  battery: 86,
                  car_count: 3,
                  control_mode: 2,
                  motion_state: 2,
                  obstacle_count: 3,
                  pedstrain_count: 4,
                  TL_green: true,
                  TL_red: false,
                  TL_yellow: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// top bar
class TopBar extends StatelessWidget {
  final String gear;
  final bool hazard;
  const TopBar({super.key, required this.gear, required this.hazard});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return Stack(
      children: [
        Stack(
          children: [
            GlassCard(
              width: r.w(1243),
              height: r.h(40),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(r.sp(100)),
                bottomRight: Radius.circular(r.sp(100)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: r.w(48)),
                child: Row(
                  children: [
                    //time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '12:15',
                          style: TextStyle(
                            color: AppColor.primary_text_dark,
                            fontFamily: 'Nasalization',
                            fontSize: r.sp(16),
                          ),
                        ),
                        SizedBox(width: r.w(4)),
                        Text(
                          'AM',
                          style: TextStyle(
                            color: AppColor.primary_text_dark,
                            fontFamily: 'inter',
                            fontSize: r.sp(10),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    //temperature
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '27',
                          style: TextStyle(
                            color: AppColor.primary_text_dark,
                            fontFamily: 'Nasalization',
                            fontSize: r.sp(16),
                          ),
                        ),
                        SizedBox(width: r.w(4)),
                        Text(
                          'C',
                          style: TextStyle(
                            color: AppColor.primary_text_dark,
                            fontFamily: 'Nasalization',
                            fontSize: r.sp(16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: GlassCard(
                width: r.w(400),
                height: r.h(70),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(r.sp(100)),
                  bottomRight: Radius.circular(r.sp(100)),
                ),
                child: Center(child: GearSelector(activeLetter: gear)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//bottom bar
class BottomBar extends StatelessWidget {
  final double battery;
  final int control_mode; //(AUTO = 2 /MANUAL = 1 /NONE = 0)
  final int motion_state; //(STOPPED = 1 /MOVING = 2 /DECELERATING = 3 /NONE = 0)
  final int car_count;
  final int obstacle_count;
  final int pedstrain_count;
  final bool TL_red;
  final bool TL_green;
  final bool TL_yellow;

  const BottomBar({
    super.key,
    required this.battery,
    required this.car_count,
    required this.control_mode,
    required this.motion_state,
    required this.obstacle_count,
    required this.pedstrain_count,
    required this.TL_green,
    required this.TL_red,
    required this.TL_yellow,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return GlassCard(
      height: r.h(60),
      width: r.w(1400),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w(24)),
        child: Row(
          children: [
            //left row
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  build_battery(r),
                  SizedBox(width: r.w(48)),
                  build_control_mode(r, control_mode),
                  SizedBox(width: r.w(48)),
                  build_motion_state(r, motion_state),
                ],
              ),
            ),

            //traffic lights
            Center(child: buildTrafficLight(TL_red, TL_yellow, TL_green)),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  build_icon(r, 'assets/icons/car.svg', car_count),
                  SizedBox(width: r.w(30)),
                  build_icon(r, 'assets/icons/obstacle.svg', obstacle_count),
                  SizedBox(width: r.w(30)),
                  build_icon(r, 'assets/icons/pedstrain.svg', pedstrain_count),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row build_icon(ResponsiveLayout r, String icon_path, int count) {
    return Row(
      children: [
        SvgPicture.asset(
          icon_path,
          width: r.w(25),
          height: r.h(20),
          colorFilter: ColorFilter.mode(
            AppColor.icon_dark_white,
            BlendMode.srcIn,
          ),
        ),
        Container(
          height: r.h(20),
          child: VerticalDivider(color: AppColor.action_color, thickness: 1),
        ),
        Text(
          '$count',
          style: TextStyle(
            color: AppColor.action_color,
            fontFamily: 'Nasalization',
            fontSize: r.sp(18),
          ),
        ),
      ],
    );
  }

  Row build_battery(ResponsiveLayout r) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/battery.svg',
          width: r.w(50),
          height: r.h(30),
          colorFilter: ColorFilter.mode(
            AppColor.icon_dark_white,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: r.w(4)),
        Text(
          '$battery%',
          style: TextStyle(
            color: AppColor.icon_dark_white,
            fontFamily: 'Nasalization',
            fontSize: r.fontSm,
          ),
        ),
      ],
    );
  }

  Text build_control_mode(ResponsiveLayout r, int v) {
    String mode = '';
    switch (v) {
      case 1:
        mode = 'MANUAL';
        break;
      case 2:
        mode = 'AUTO';
        break;
      default:
        mode = '';
    }
    return Text(
      mode,
      style: TextStyle(
        color: AppColor.action_color,
        fontFamily: 'inter',
        fontSize: r.sp(16),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Row build_motion_state(ResponsiveLayout r, int v) {
    String motion = '';
    switch (v) {
      case 1:
        motion = 'STOPPED';
        break;
      case 2:
        motion = 'MOVING';
        break;
      case 3:
        motion = 'DECELERATING';
        break;
      default:
        motion = '';
    }
    return Row(
      children: [
        if (v == 1 || v == 2 || v == 3)
          SvgPicture.asset(
            'assets/icons/blue_filled_circle.svg',
            width: r.sp(20),
            height: r.sp(20),
          ),
        SizedBox(width: r.w(8)),
        Text(
          motion,
          style: TextStyle(
            color: AppColor.action_color,
            fontFamily: 'inter',
            fontSize: r.sp(16),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

//right card information
class RightCarfIngo extends StatelessWidget {
  final double eta_distance;
  final double eta_time;
  final double odometer;
  final String mrm;
  const RightCarfIngo({
    super.key,
    required this.eta_distance,
    required this.eta_time,
    required this.mrm,
    required this.odometer,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return GlassCard(
      width: r.w(200),
      height: r.h(350),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.w(24), r.h(24), 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: build_info(r, 'Estimated Distance', eta_distance, 'm'),
            ),
            build_light_line(r),
            Expanded(child: build_info(r, 'Estimated Time', eta_time, 's')),
            build_light_line(r),
            Expanded(child: build_info(r, 'Odometer', odometer, 'm')),
            build_light_line(r),
            Expanded(child: build_info(r, 'MRM', mrm, '')),
          ],
        ),
      ),
    );
  }
}

// left card information
class LeftCardInfo extends StatelessWidget {
  final double acc;
  final double target_speed;
  final double max_speed;
  final double yaw_rate;

  const LeftCardInfo({
    super.key,
    required this.acc,
    required this.max_speed,
    required this.target_speed,
    required this.yaw_rate,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return GlassCard(
      width: r.w(200),
      height: r.h(350),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.w(24), r.h(24), 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: build_info(r, 'Acceleration', acc, 'KM/H')),
            build_light_line(r),
            Expanded(child: build_info(r, 'Target Speed', target_speed, 'm/s')),
            build_light_line(r),
            Expanded(child: build_info(r, 'Max Speed', max_speed, 'm/s')),
            build_light_line(r),
            Expanded(child: build_info(r, 'Yaw Rate', yaw_rate, 'Rad/s')),
          ],
        ),
      ),
    );
  }
}

Image build_light_line(ResponsiveLayout r) {
  return Image.asset(
    'assets/images/light_line.png',
    width: r.w(180),
    height: r.h(20),
    fit: BoxFit.fitWidth,
  );
}

Column build_info(
    ResponsiveLayout r, String label, dynamic value, String unit) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColor.secondary_text_dark,
          fontSize: r.fontSm,
          fontFamily: 'inter',
          fontWeight: FontWeight.w200,
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: AppColor.action_color,
              fontFamily: 'Nasalization',
              fontSize: r.sp(20),
            ),
          ),
          SizedBox(width: r.w(4)),
          Text(
            unit,
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontFamily: 'inter',
              fontSize: r.sp(12),
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    ],
  );
}

//speed and energy display
Row build_display(ResponsiveLayout r, double val, String unit) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Text(
        '$val',
        style: TextStyle(
          color: AppColor.primary_text_dark,
          fontFamily: 'Nasalization',
          fontSize: r.sp(70),
        ),
      ),
      Text(
        unit,
        style: TextStyle(
          color: AppColor.secondary_text_dark,
          fontFamily: 'inter',
          fontSize: r.sp(15),
          fontWeight: FontWeight.w200,
        ),
      ),
    ],
  );
}
