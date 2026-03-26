class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  @override
  String toString() =>
      'LocationData(lat: $latitude, lon: $longitude, accuracy: $accuracy)';
}