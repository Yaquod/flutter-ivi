import 'package:flutter/material.dart';
import 'package:flutter_ivi/ui_components/glass_card.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/connectivity_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final Stream<DateTime> _clockStream = Stream.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<DateTime>(
          stream: _clockStream,
          initialData: DateTime.now(),
          builder: (context, snapshot) {
            final now = snapshot.data ?? DateTime.now();

            final formattedTime = DateFormat('HH:mm').format(now);

            final formattedDate = DateFormat('EEEE | MMM d, yyyy').format(now);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  formattedTime,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColor().textColor,
                    ),
                  ),
                ),

                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColor().textColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(width: 32),

        Expanded(
          child: GlassCard(
            borderRadius: BorderRadius.circular(50),
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
            child:  TextField(
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xff666666)),

                  hintText: "Search",

                  hintStyle: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666),
                    ),
                  ),

                  border: InputBorder.none,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(width: 160),

        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            const ConnectivityIcon(),

            const SizedBox(width: 15),

            const Icon(Icons.bluetooth, color: Colors.white, size: 18),

            const SizedBox(width: 15),

            const Icon(
              Icons.battery_charging_full,
              color: Colors.white,
              size: 18,
            ),

            const SizedBox(width: 25),

            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: Colors.white70, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}
