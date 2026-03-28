class WeatherData {
  final double temperature;
  final double windSpeed;
  final double? precipitation;
  final int weatherCode;
  final DateTime time;
  final double latitude;
  final double longitude;

  const WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>;


    return WeatherData(
      temperature: (currentWeather['temperature'] as num).toDouble(),
      windSpeed: (currentWeather['windspeed'] as num).toDouble(),
      precipitation: null,
      weatherCode: currentWeather['weathercode'] as int,
      time: DateTime.parse(currentWeather['time'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
