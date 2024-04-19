// part of 'weather_bloc.dart';
//
// @immutable
// sealed class WeatherState {}
//
// final class WeatherInitial extends WeatherState {}
//
// class WeatherLoading extends WeatherState {}
//
// class WeatherLoaded extends WeatherState {
//   final WeatherModel weather;
//
//    WeatherLoaded({required this.weather});
//
//   @override
//   List<Object> get props => [weather];
// }
//
// class WeatherError extends WeatherState {
//   final String message;
//
//    WeatherError({required this.message});
//
//   @override
//   List<Object> get props => [message];
// }



part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {

  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModelNew weather;

  const WeatherLoaded({required this.weather});

  @override
  List<Object> get props => [weather];
}
class ItemSelected extends WeatherState {
  final int index;

  ItemSelected({required this.index});

  @override
  List<Object> get props => [index];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object> get props => [message];
}