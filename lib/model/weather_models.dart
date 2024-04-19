// To parse this JSON data, do
//
//     final weatherModelNew = weatherModelNewFromJson(jsonString);

import 'dart:convert';

WeatherModelNew weatherModelNewFromJson(String str) => WeatherModelNew.fromJson(json.decode(str));

String weatherModelNewToJson(WeatherModelNew data) => json.encode(data.toJson());

class WeatherModelNew {
  double latitude;
  double longitude;
  double generationtimeMs;
  int utcOffsetSeconds;
  String timezone;
  String timezoneAbbreviation;
  double elevation;
  HourlyUnits hourlyUnits;
  Hourly hourly;

  WeatherModelNew({
    required this.latitude,
    required this.longitude,
    required this.generationtimeMs,
    required this.utcOffsetSeconds,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.elevation,
    required this.hourlyUnits,
    required this.hourly,
  });

  factory WeatherModelNew.fromJson(Map<String, dynamic> json) => WeatherModelNew(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
    hourly: Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "hourly_units": hourlyUnits.toJson(),
    "hourly": hourly.toJson(),
  };
}

class Hourly {
  List<String> time;
  List<double> temperature2M;
  List<int> relativeHumidity2M;
  List<double> windSpeed10M;

  Hourly({
    required this.time,
    required this.temperature2M,
    required this.relativeHumidity2M,
    required this.windSpeed10M,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: List<String>.from(json["time"].map((x) => x)),
    temperature2M: List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
    relativeHumidity2M: List<int>.from(json["relative_humidity_2m"].map((x) => x)),
    windSpeed10M: List<double>.from(json["wind_speed_10m"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time.map((x) => x)),
    "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
    "relative_humidity_2m": List<dynamic>.from(relativeHumidity2M.map((x) => x)),
    "wind_speed_10m": List<dynamic>.from(windSpeed10M.map((x) => x)),
  };
}

class HourlyUnits {
  String time;
  String temperature2M;
  String relativeHumidity2M;
  String windSpeed10M;

  HourlyUnits({
    required this.time,
    required this.temperature2M,
    required this.relativeHumidity2M,
    required this.windSpeed10M,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],
    relativeHumidity2M: json["relative_humidity_2m"],
    windSpeed10M: json["wind_speed_10m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
    "relative_humidity_2m": relativeHumidity2M,
    "wind_speed_10m": windSpeed10M,
  };
}
