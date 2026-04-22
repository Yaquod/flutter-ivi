import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/lock_button.dart';
import 'package:flutter_ivi/ui_components/door_rect.dart';
import 'package:flutter_ivi/ui_components/car_body_painter.dart';
import 'package:flutter_ivi/screens/car_screen_door.dart';




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
    return Center(
      child: SizedBox(
        width: 320,
        height: 520,
        child: Stack(
          alignment: Alignment.center,
          children: [

            // car body shape 
            Positioned.fill(
            child :CustomPaint(
           
              painter: CarBodyPainter(),
            ),),



            // door rect and lock button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // front door rect and lock door 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LockIconButton(
                          isLocked: doors[DoorPosition.driverFront]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.driverFront),
                        ),
                    
                        const SizedBox(width: 6),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.driverFront,
                            onTap: () => onSelectDoor(DoorPosition.driverFront),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.passengerFront,
                            onTap: () => onSelectDoor(DoorPosition.passengerFront),
                          ),
                        ),
                        const SizedBox(width: 6),
                        LockIconButton(
                          isLocked: doors[DoorPosition.passengerFront]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.passengerFront),
                        ),
                      ],
                    ),
                  ),
                ),

                //const SizedBox(height: 8),

                 // rear door rect and lock door 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LockIconButton(
                          isLocked: doors[DoorPosition.driverRear]!.isLocked,
                          onTap: () => onToggleLock(DoorPosition.driverRear),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.driverRear,
                            onTap: () => onSelectDoor(DoorPosition.driverRear),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: DoorRect(
                            isSelected: selected == DoorPosition.passengerRear,
                            onTap: () => onSelectDoor(DoorPosition.passengerRear),
                          ),
                        ),
                        const SizedBox(width: 6),
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



