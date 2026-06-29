
import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavMessage extends StatelessWidget {
  final int turnDirection; // 0=none 1=left 2=right
  final double distanceM;

  const NavMessage({super.key, required this.turnDirection, required this.distanceM});

  @override
  Widget build(BuildContext context) {
    if (turnDirection == 0) return const SizedBox.shrink();

    final isLeft = turnDirection == 1;

    return 
         Row(
          mainAxisSize: MainAxisSize.min,
          children: [


            // arrow icon
             SvgPicture.asset(
             isLeft? 'assets/icons/left_arrow.svg':'assets/icons/right_arrow.svg',
            
            width: 48,
            height: 48,
         
        ),


            

            const SizedBox(width: 20),

            // distance + label
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDistance(distanceM),
                  style: const TextStyle(
                    color:AppColor.action_color,
                    fontFamily: 'Nasalization',
                    fontSize: 24,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLeft ? 'Turn Left' : 'Turn Right',
                  style:  TextStyle(
                    color: Colors.white,
                    fontFamily: 'inter',
                    fontSize: 20,
                    height: 1,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w200
                  ),
                ),
              ],
            ),
          ],
       
    );
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} km';
    return '${meters.toStringAsFixed(0)} m';
  }
}