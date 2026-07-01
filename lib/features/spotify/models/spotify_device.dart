class SpotifyDevice {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final bool isRestricted;
  final int volumePercent;

  const SpotifyDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.isRestricted,
    required this.volumePercent,
  });

  factory SpotifyDevice.fromJson(Map<String, dynamic> json) => SpotifyDevice(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        isActive: json['is_active'] as bool,
        isRestricted: json['is_restricted'] as bool,
        volumePercent: json['volume_percent'] as int? ?? 0,
      );
}
