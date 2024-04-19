import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyWeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  DailyWeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final List<String> time = weatherData['time'];
    final List<double> temperatures = weatherData['temperature_2m'];

    Map<String, List<double>> dailyTemperatures = {};

    // Organize temperatures by day
    for (int i = 0; i < time.length; i++) {
      DateTime dateTime = DateTime.parse(time[i]);
      String dayKey = DateFormat('yyyy-MM-dd').format(dateTime);
      if (!dailyTemperatures.containsKey(dayKey)) {
        dailyTemperatures[dayKey] = [];
      }
      dailyTemperatures[dayKey]!.add(temperatures[i]);
    }

    // Find highest and lowest temperatures for each day
    Map<String, Map<String, double>> dailyMinMaxTemperatures = {};
    dailyTemperatures.forEach((key, value) {
      double maxTemp = value.reduce((curr, next) => curr > next ? curr : next);
      double minTemp = value.reduce((curr, next) => curr < next ? curr : next);
      dailyMinMaxTemperatures[key] = {'max': maxTemp, 'min': minTemp};
    });

    return ListView.builder(
      itemCount: dailyMinMaxTemperatures.length,
      itemBuilder: (context, index) {
        String dayKey = dailyMinMaxTemperatures.keys.toList()[index];
        DateTime dateTime = DateTime.parse(dayKey);
        String dayName = DateFormat('EEEE').format(dateTime);

        double maxTemp = dailyMinMaxTemperatures[dayKey]!['max']!;
        double minTemp = dailyMinMaxTemperatures[dayKey]!['min']!;

        return ListTile(
          title: Text(dayName),
          subtitle: Text('Highest: $maxTemp°C, Lowest: $minTemp°C'),
        );
      },
    );
  }
}