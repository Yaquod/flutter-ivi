import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/constants/app_color.dart';
import 'package:flutter_ivi/widgets/responsive_layout.dart';
import '../providers/spotify_provider.dart';
import '../models/spotify_device.dart';

class DeviceSelectorSheet extends StatefulWidget {
  const DeviceSelectorSheet({super.key});

  @override
  State<DeviceSelectorSheet> createState() => _DeviceSelectorSheetState();
}

class _DeviceSelectorSheetState extends State<DeviceSelectorSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpotifyProvider>().loadDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    final spotify = context.watch<SpotifyProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColor.neutral_900,
        borderRadius: BorderRadius.vertical(top: Radius.circular(r.radiusXl)),
      ),
      padding: r.edgeInsetsAll(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Device',
            style: TextStyle(
              color: Colors.white,
              fontSize: r.fontLg,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: r.paddingLg),
          if (spotify.devices.isEmpty)
            Padding(
              padding: r.edgeInsetsAll(32),
              child: Text(
                'No devices found. Is spotifyd running?',
                style: TextStyle(
                  color: AppColor.secondary_text_dark,
                  fontSize: r.fontSm,
                ),
              ),
            )
          else
            ...spotify.devices.map((d) => _DeviceTile(device: d)),
          SizedBox(height: r.paddingMd),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final SpotifyDevice device;
  const _DeviceTile({required this.device});

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveLayout.of(context);
    return ListTile(
      leading: Icon(
        _iconForType(device.type),
        color: device.isActive ? AppColor.action_color : AppColor.secondary_text_dark,
        size: r.iconSm,
      ),
      title: Text(
        device.name,
        style: TextStyle(
          color: device.isActive ? AppColor.action_color : Colors.white,
          fontWeight: device.isActive ? FontWeight.w700 : FontWeight.w400,
          fontSize: r.fontSm,
        ),
      ),
      subtitle: Text(
        device.type,
        style: TextStyle(
          color: AppColor.secondary_text_dark,
          fontSize: r.fontXs,
        ),
      ),
      trailing: device.isActive
          ? Icon(Icons.volume_up, color: AppColor.action_color, size: r.iconXs)
          : null,
      onTap: () {
        context.read<SpotifyProvider>().transferTo(device.id);
        Navigator.of(context).pop();
      },
    );
  }

  IconData _iconForType(String type) => switch (type.toLowerCase()) {
        'smartphone' => Icons.smartphone,
        'computer' => Icons.computer,
        'speaker' => Icons.speaker,
        'tv' => Icons.tv,
        _ => Icons.device_unknown,
      };
}
