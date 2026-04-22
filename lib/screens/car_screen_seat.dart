import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/control_card.dart';
import 'package:flutter_ivi/ui_components/toggle_button.dart';


class SeatPage extends StatefulWidget {
  const SeatPage({super.key});

  @override
  State<SeatPage> createState() => SeatPageState();
}

class SeatPageState extends State<SeatPage> {
  bool _isDriver = true;

  //Driver values
  double _driverPosition = 0;
  double _driverHeight   = 0;
  double _driverRecline  = 0;

  // Passenger values
  double _passengerPosition = 0;
  double _passengerHeight   = 0;
  double _passengerRecline  = 0;

  @override
  Widget build(BuildContext context) {

    //active value based on selected seat
    final double position = _isDriver ? _driverPosition : _passengerPosition;
    final double height   = _isDriver ? _driverHeight   : _passengerHeight;
    final double recline  = _isDriver ? _driverRecline  : _passengerRecline;




    return Container(
      child : Column(
        children: [

          //seat image
          Expanded(
            flex:9,
            child: Image.asset('assets/images/seat.png'),
            ),


          

            //toggle button
            Expanded(
              flex:2,
              child: DriverPassengerToggle(
                isDriver: _isDriver, 
                onChanged:(val) => setState(() => _isDriver = val),
                ),
            ),

              Spacer(flex:1),

            //3 control card position , height , recline 
             Expanded(
                flex:7,
                child:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                                
                      //position card 
                      Expanded(flex:10,child: ControlCard(label: 'Position', unit: 'mm', max: 100, min: 0, initial_val: position, step: 10,
                      onChanged: (val) => setState(() {
                            if (_isDriver) _driverPosition = val;
                            else _passengerPosition = val;
                          }
                      )
                      )),


                      Spacer(flex:1),
                                
                                
                                
                      //height card 
                       Expanded(flex:10,child: ControlCard(label: 'Height', unit: 'mm', max: 100, min: 0, initial_val: height, step: 10,
                      onChanged: (val) => setState(() {
                            if (_isDriver) _driverHeight = val;
                            else _passengerHeight = val;
                          }
                      )
                      )),
                                
                      
                       Spacer(flex:1),


                      //recline card 
                        Expanded(flex:10,child: ControlCard(label: 'Recline', unit: '°', max: 90, min: -90, initial_val: recline, step: 15,
                      onChanged: (val) => setState(() {
                            if (_isDriver) _driverRecline = val;
                            else _passengerRecline = val;
                          }
                      )
                      )),
                                
                                
                      
                     
                    ],
                  ),
                ) 
              
            )






        ],
      )
    );

    
  }
}



