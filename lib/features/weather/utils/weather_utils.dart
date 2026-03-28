class WeatherUtils {
  static const Map<int, String> weatherDescriptions = {
    0: 'Clear sky',
    1: 'Partly cloudy',
    2: 'Partly cloudy',
    3: 'Partly cloudy',
    45: 'Foggy',
    48: 'Foggy',
    51: 'Drizzle',
    53: 'Drizzle',
    55: 'Drizzle',
    61: 'Rain',
    63: 'Rain',
    65: 'Rain',
    71: 'Snow',
    73: 'Snow',
    75: 'Snow',
    77: 'Snow grains',
    80: 'Rain showers',
    81: 'Rain showers',
    82: 'Rain showers',
    85: 'Snow showers',
    86: 'Snow showers',
    95: 'Thunderstorm',
    96: 'Thunderstorm with hail',
    99: 'Thunderstorm with hail',
  };

  static const Map<int, String> weatherIcons = {
    0: '☀️',
    1: '⛅',
    2: '⛅',
    3: '⛅',
    45: '🌫️',
    48: '🌫️',
    51: '🌦️',
    53: '🌦️',
    55: '🌦️',
    61: '🌧️',
    63: '🌧️',
    65: '🌧️',
    71: '❄️',
    73: '❄️',
    75: '❄️',
    77: '🌨️',
    80: '🌦️',
    81: '🌦️',
    82: '🌦️',
    85: '🌨️',
    86: '🌨️',
    95: '⛈️',
    96: '⛈️',
    99: '⛈️',
  };

  static String getDescription(int code) {
    return weatherDescriptions[code] ?? 'Unknown';
  }

  static String getIcon(int code) {
    return weatherIcons[code] ?? '🌡️';
  }
}