import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/weather_models.dart';
 class WeatherRepository {

   final String baseUrl = 'https://api.open-meteo.com/v1/forecast';

   Future<WeatherModelNew> fetchWeather(double latitude,double longitude ) async {
     // final latitude = 52.52;
     // final longitude = 13.41;
     final futureDays = 7;
     final url = Uri.parse('$baseUrl?latitude=$latitude&longitude=$longitude&future_days=$futureDays&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m');
     final response = await http.get(url);
     print(response.statusCode);
     if (response.statusCode == 200) {
       final jsonBody = jsonDecode(response.body);
       final weatherData = WeatherModelNew.fromJson(jsonBody);
       return weatherData;
     } else {
       throw Exception('Failed to fetch weather data');
     }
   }
 }
