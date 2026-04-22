import 'package:flutter/material.dart';
// import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/screens/car_dashboard.dart' ; 
import 'package:flutter_ivi/ui_components/airflow_direction.dart' ; 

class CarScreen extends StatelessWidget {
  const CarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    //Scaffold(); 
    const CarDashboard(); 
  }
}
