import 'package:flutter/material.dart';
import 'package:flutter_ivi/screens/car_screen_hvac.dart';
import 'package:flutter_ivi/ui_components/menu_selector.dart';
import 'package:flutter_ivi/screens/car_screen_seat.dart';
import 'package:flutter_ivi/screens/car_screen_door.dart';
import 'package:flutter_ivi/screens/car_screen_car.dart';




class CarDashboard extends StatefulWidget {
  const CarDashboard({super.key});

  @override
  State<CarDashboard> createState() => _CarDashboardState();
}

class _CarDashboardState extends State<CarDashboard> {
  int selectedIndex = 0;

  final pages = [
    const HVACPage(),
    SeatPage(),
    DoorsPage(),
    CarPage(),
  ];

 @override
Widget build(BuildContext context) {
  return Row(
    children: [
      SideMenu(
        items: const ["HVAC", "Seat", "Doors", "Car"],
        selectedIndex: selectedIndex,
        onChanged: (index) {
          setState(() => selectedIndex = index);
        },
      ),

      Expanded(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
    ],
  );
}
}

// class SeatPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Seat Controls"),
//     );
//   }
// }


// class DoorsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Door Controls"),
//     );
//   }
// }


// class CarPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text("Car Controls"),
//     );
//   }
// }
