import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/circular_progress.dart';
import 'package:flutter_ivi/ui_components/car_top_view_animated.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';

enum DoorPosition { driverFront, passengerFront, driverRear, passengerRear }

extension DoorPositionLabel on DoorPosition {
  String get label {
    switch (this) {
      case DoorPosition.driverFront:    return 'Driver';
      case DoorPosition.passengerFront: return 'Passenger';
      case DoorPosition.driverRear:     return 'Rear Left';
      case DoorPosition.passengerRear:  return 'Rear Right';
    }
  }
}

class DoorState {
  bool isLocked;
  double windowPercent;

  DoorState({this.isLocked = false, this.windowPercent = 0.5});
}

class DoorsPage extends StatefulWidget {
  const DoorsPage({super.key});

  @override
  State<DoorsPage> createState() => _DoorsPageState();
}

class _DoorsPageState extends State<DoorsPage> {
  DoorPosition _selected = DoorPosition.driverFront;

  final Map<DoorPosition, DoorState> _doors = {
    DoorPosition.driverFront:    DoorState(),
    DoorPosition.passengerFront: DoorState(),
    DoorPosition.driverRear:     DoorState(),
    DoorPosition.passengerRear:  DoorState(),
  };

  void _lockAllDoors() =>
      setState(() { for (final d in _doors.values) d.isLocked = true; });

  void _closeAllWindows() =>
      setState(() { for (final d in _doors.values) d.windowPercent = 0.0; });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final current = _doors[_selected]!;

    return Padding(
      padding: r.edgeInsetsAll(24),
      child: Column(
        children: [

          Expanded(
            flex:15,
            child: Row(
              children: [

                Expanded(
                  flex: 6,
                  child: CarTopView(
                    doors: _doors,
                    selected: _selected,
                    onSelectDoor: (pos) => setState(() => _selected = pos),
                    onToggleLock: (pos) => setState(() =>
                        _doors[pos]!.isLocked = !_doors[pos]!.isLocked),
                  ),
                ),

                Spacer(flex: 1),

                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: r.edgeInsetsOnly(r: 32),
                    child: _WindowControlPanel(
                      label: _selected.label,
                      doorState: current,
                      onWindowChanged: (val) =>
                          setState(() => current.windowPercent = val),
                      onOpen:  () => setState(() => current.windowPercent = 1.0),
                      onClose: () => setState(() => current.windowPercent = 0.0),
                    ),
                  ),
                ),

              ],
            ),
          ),

         Spacer(flex:1),

          Expanded(
            flex:2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BottomButton(label: 'Lock all Doors',   onTap: _lockAllDoors),
                SizedBox(width: r.w(16)),
                _BottomButton(label: 'Lock all Windows', onTap: _closeAllWindows),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _WindowControlPanel extends StatelessWidget {
  final String label;
  final DoorState doorState;
  final ValueChanged<double> onWindowChanged;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const _WindowControlPanel({
    required this.label,
    required this.doorState,
    required this.onWindowChanged,
    required this.onOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final int percent = (doorState.windowPercent * 100).round();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            'Window Control',
            style: TextStyle(
              color: AppColor.primary_text_dark,
              fontSize: r.sp(22),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: r.h(4)),
          Text(
            label,
            style: TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: r.sp(14),
            ),
          ),

          SizedBox(height: r.h(24)),

          CircularProgress(Val: doorState.windowPercent, percent: percent),

          SizedBox(height: r.h(24)),

          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor:   AppColor.action_color,
                inactiveTrackColor: AppColor.card_second_dark.withOpacity(0.25),
                thumbColor:         AppColor.action_color,
                overlayColor:       AppColor.action_color.withOpacity(0.20),
                trackHeight: r.h(4),
              ),
              child: Slider(
                value: doorState.windowPercent,
                min: 0.0,
                max: 1.0,
                onChanged: onWindowChanged,
              ),
            ),
          ),

          SizedBox(height: r.h(24)),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: r.h(56),
                  child: _ActionButton(label: 'Open',  onTap: onOpen),
                ),
              ),
              SizedBox(width: r.w(16)),
              Expanded(
                child: SizedBox(
                  height: r.h(56),
                  child: _ActionButton(label: 'Close', onTap: onClose),
                ),
              ),
            ],
          ),

        ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.sp(12)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:   Alignment.bottomRight,
              colors: [
                AppColor.card_first_dark.withOpacity(0.25),
                AppColor.card_second_dark.withOpacity(0.25),
              ],
            ),
            border: Border.all(
              color: _isHovered
                  ? AppColor.action_color
                  : AppColor.card_border_second_dark.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: AppColor.primary_text_dark,
                fontSize: r.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _BottomButton({required this.label, required this.onTap});

  @override
  State<_BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<_BottomButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);

    return GestureDetector(
      onTap: () {
        setState(() => _isPressed = !_isPressed);
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width:  r.w(200),
          height: r.h(56),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.sp(16)),
            color: _isPressed
                ? AppColor.action_color
                : AppColor.card_first_dark.withOpacity(0.40),
            border: Border.all(
              color: (_isHovered || _isPressed)
                  ? AppColor.action_color
                  : AppColor.card_border_second_dark.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: AppColor.primary_text_dark,
                fontSize: r.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
