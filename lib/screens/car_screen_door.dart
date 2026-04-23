import 'package:flutter/material.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/ui_components/circular_progress.dart';
import 'package:flutter_ivi/ui_components/car_top_view_animated.dart';

// ─── Door Position ────────────────────────────────────────────────────────────

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

// ─── Door State ───────────────────────────────────────────────────────────────

class DoorState {
  bool isLocked;
  double windowPercent;

  DoorState({this.isLocked = false, this.windowPercent = 0.5});
}

// ─── Doors Page ───────────────────────────────────────────────────────────────

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
    final current = _doors[_selected]!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

          // car top view and window control 
          Expanded(
            flex:15,
            child: Row(
              children: [

              //car animated top view 
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

                //window control pannel
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
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

         // const SizedBox(height: 24),
         Spacer(flex:1),

          // ── Bottom buttons ──────────────────────────────────
          Expanded(
            flex:2,
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BottomButton(label: 'Lock all Doors',   onTap: _lockAllDoors),
                const SizedBox(width: 16),
                _BottomButton(label: 'Lock all Windows', onTap: _closeAllWindows),
              ],
            ),
          ),

        ],
      ),
    );
  }
}





// ─── Window Control Panel ─────────────────────────────────────────────────────

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
    final int percent = (doorState.windowPercent * 100).round();

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
         //label
          const Text(
            'Window Control',
            style: TextStyle(
              color: AppColor.primary_text_dark,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColor.secondary_text_dark,
              fontSize: 14,
            ),
          ),
      
          const SizedBox(height: 24),
      
          // circular progress
           CircularProgress(Val: doorState.windowPercent, percent: percent),
      
          const SizedBox(height: 24),
      
          //slider
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor:   AppColor.action_color,
                inactiveTrackColor: AppColor.card_second_dark.withOpacity(0.25),
                thumbColor:         AppColor.action_color,
                overlayColor:       AppColor.action_color.withOpacity(0.20),
                trackHeight: 4,
              ),
              child: Slider(
                value: doorState.windowPercent,
                min: 0.0,
                max: 1.0,
                onChanged: onWindowChanged,
              ),
            ),
          ),
      
          const SizedBox(height: 24),
      
          // ── Open / Close buttons ──────────────────────────
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: _ActionButton(label: 'Open',  onTap: onOpen),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: _ActionButton(label: 'Close', onTap: onClose),
                ),
              ),
            ],
          ),
      
        ],
   
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

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
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(
                color: AppColor.primary_text_dark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Button ────────────────────────────────────────────────────────────

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
          width:  200,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
              style: const TextStyle(
                color: AppColor.primary_text_dark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



