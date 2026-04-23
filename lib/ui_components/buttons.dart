import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';


class Button extends StatefulWidget {
  // final double width;
  // final double height;
  final String label ;
  final double font_size ; 

  const Button({
    super.key , 
    // required this.width,
    // required this.height,
    required this.label,
    required this.font_size ,
     
  
  });

  

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
   
   bool _isHovered = false ;
   bool _isPressed = false ; 


   BoxDecoration _BuildDecoration() {

    final base_gradient = LinearGradient(
      begin: Alignment.topLeft,
      end : Alignment.bottomRight ,
      stops: const [0.0 , 0.66],
      colors: [
        AppColor.card_first_dark.withOpacity(0.25),
        AppColor.card_second_dark.withOpacity(0.25),
      ]
    );


      final base_shadow =  BoxShadow(
        color : Colors.black.withOpacity(0.25),
        blurRadius: 4,
        offset: const Offset(0, 4),

      );


      return BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient:  !_isPressed? base_gradient : null , 
        color : _isPressed?AppColor.action_color:null , 
        boxShadow: [base_shadow] , 
        border:Border.all(
          color : (_isHovered || _isPressed)? AppColor.action_color : Colors.transparent ,
          width: 1, 
        )
      );
   }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isPressed = !_isPressed),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: SizedBox(
          width: 120,
          height: 60,

          child : Stack(
            alignment: Alignment.center,
           children: [
            
            
          
          Container(
            decoration: _BuildDecoration(),
          ),


          Text(
            widget.label,
            style:  TextStyle(
            color: AppColor.primary_text_dark,
            fontSize: widget.font_size,
            fontWeight: FontWeight.w500,
          ),
          ),
           
           ], 

            

          )
        ),
      ),
    );
    ;
  }
}