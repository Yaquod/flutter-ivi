import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/new_card.dart';


class CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({super.key, required this.icon, required this.onTap});

  @override
  State<CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<CircleIconButton> {
  bool _isHovered = false;
  

  static const double size = 50.0;

  @override
  Widget build(BuildContext context) {
  

    final Color iconColor = AppColor.icon_dark_white;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
             
               //base for circle button
                 GlassCard(
                  width: size,
                  height: size,
                  borderRadius: size / 2,
                
              ),
              

              //hovered state layer

              if (_isHovered)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.action_color.withOpacity(0.15),
                  ),
                ),

              Center(child: Icon(widget.icon, color: iconColor, size: 25)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── display temperature value ──────────────────────────────────────────────────────

class TempDisplay extends StatelessWidget {
  final double temperature;

  const TempDisplay({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${temperature.toStringAsFixed(1)}°',
      style: const TextStyle(
        color: AppColor.primary_text_dark,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        //fontFamily: roboto
      ),
    );
  }
}

// ─── Temperature Card ─────────────────────────────────────────────────────────

class TemperatureCard extends StatefulWidget {
  const TemperatureCard({super.key});

  @override
  State<TemperatureCard> createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  double _leftTemp = 20.5;
  double _rightTemp = 20.5;

  static const double _minTemp = 16.0;
  static const double _maxTemp = 32.0;
  static const double _step = 0.5;

  void _adjustTemp(bool isLeft, bool increment) {
    setState(() {
      if (isLeft) {
        _leftTemp = (_leftTemp + (increment ? _step : -_step)).clamp(
          _minTemp,
          _maxTemp,
        );
      } else {
        _rightTemp = (_rightTemp + (increment ? _step : -_step)).clamp(
          _minTemp,
          _maxTemp,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 650,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(57.5),
          topRight: Radius.circular(57.5),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.66],
          colors: [
            AppColor.card_first_dark.withOpacity(0.25),
            AppColor.card_second_dark.withOpacity(0.25),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],

        border: Border.all(
          color: AppColor.action_color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
     

      
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8) ,
        //wrap left temp row , right temp row and cooling icon
        child: Row(
       //   mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween , 
          
           
          children: [
            
        
            //left row that wrap left minus , left plus , left temp
            Expanded(
              flex : 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    // ── Left: minus ───────────────────────────────────
                  CircleIconButton(
                    icon: Icons.remove,
                    onTap: () => _adjustTemp(true, false),
                  ),
                
                  
                  // ── Left temp value ───────────────────────────────
                  TempDisplay(temperature: _leftTemp),
              
                  
                  // ── Left: plus ────────────────────────────────────
                  CircleIconButton(
                    icon: Icons.add,
                    onTap: () => _adjustTemp(true, true),
                  ),
                ],
              ),
            ),
        
           
            //cooling icon
            Expanded(
              flex: 3 ,
              child: Icon(Icons.ac_unit, color: AppColor.action_color, size: 36)),
        
      
        
             //right row that wrap right minus , right plus , right temp
            Expanded(
                flex : 5,
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    // ── Right: minus ──────────────────────────────────
                  CircleIconButton(
                    icon: Icons.remove,
                    onTap: () => _adjustTemp(false, false),
                  ),
               
                  
                  // ── Right temp value ──────────────────────────────
                  TempDisplay(temperature: _rightTemp),
              
                  
                  // ── Right: plus ───────────────────────────────────
                  CircleIconButton(
                    icon: Icons.add,
                    onTap: () => _adjustTemp(false, true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
