// part of 'weather_bloc.dart';
//
// @immutable
// sealed class WeatherEvent {
//   final String location;
//     WeatherEvent({required this.location})
//   @override
//   List<Object> get props {
//     return [location];
//   }
// }
//
// class FetchWeatherEvent extends WeatherEvent {
//   final String location;
//
//   FetchWeatherEvent(this.location);
// }

//
// part of 'weather_bloc.dart';
//
//
// abstract class WeatherEvent extends Equatable {
//   final double latitude ;
//   final double longitude;
//
//   WeatherEvent({required this.longitude,required this.latitude});
//
//   @override
//   List<Object> get props => [longitude,latitude];
// }
//
// class FetchWeatherEvent extends WeatherEvent {
//   FetchWeatherEvent({required double latitude,required double longitude}) : super(latitude: latitude,longitude: longitude);
// }
import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {


  const WeatherEvent();
  //
  // @override
  // List<Object> get props => [latitude, longitude];
}

class FetchWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  FetchWeatherEvent({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
class SelectItemEvent extends WeatherEvent {
  final int index;

  SelectItemEvent({required this.index});

  @override
  List<Object> get props => [index];
}

