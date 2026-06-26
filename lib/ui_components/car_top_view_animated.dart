import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/lock_button.dart';
import 'package:flutter_ivi/ui_components/door_rect.dart';
import 'package:flutter_ivi/ui_components/car_body_painter.dart';
import 'package:flutter_ivi/screens/car_screen_door.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

class CarTopView extends StatelessWidget {
  final Map<DoorPosition, DoorState> doors;
  final DoorPosition selected;
  final ValueChanged<DoorPosition> onSelectDoor;
  final ValueChanged<DoorPosition> onToggleLock;

  const CarTopView({
    required this.doors,
    required this.selected,
    required this.onSelectDoor,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return Center(
      child: SizedBox(
        width: r.w(320),
        height: r.h(520),
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned.fill(
            child :CustomPaint(
              painter: CarBodyPainter(),
            ),),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: Padding(
                    padding: r.edgeInsetsOnly(l: 0, t: 24, r: 0, b: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LockIconButton(
                          isLocked: doors[DoorPosition.driverFront]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.driverFront),
                        ),

                        SizedBox(width: r.w(6)),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.driverFront,
                            onTap: () => onSelectDoor(DoorPosition.driverFront),
                          ),
                        ),
                        SizedBox(width: r.w(6)),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.passengerFront,
                            onTap: () => onSelectDoor(DoorPosition.passengerFront),
                          ),
                        ),
                        SizedBox(width: r.w(6)),
                        LockIconButton(
                          isLocked: doors[DoorPosition.passengerFront]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.passengerFront),
                        ),
                      ],
                    ),
                  ),
                ),

                 Expanded(
                  child: Padding(
                    padding: r.edgeInsetsOnly(l: 0, t: 0, r: 0, b: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LockIconButton(
                          isLocked: doors[DoorPosition.driverRear]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.driverRear),
                        ),
                        SizedBox(width: r.w(6)),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.driverRear,
                            onTap: () => onSelectDoor(DoorPosition.driverRear),
                          ),
                        ),
                        SizedBox(width: r.w(6)),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.passengerRear,
                            onTap: () => onSelectDoor(DoorPosition.passengerRear),
                          ),
                        ),
                        SizedBox(width: r.w(6)),
                        LockIconButton(
                          isLocked: doors[DoorPosition.passengerRear]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.passengerRear),
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
    );
  }
}
