
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_bloc/bloc/weather_event.dart';
import 'package:flutter_weather_bloc/model/weather_models.dart';

import '../repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(WeatherLoading(),);
      try {

        final weather = await repository.fetchWeather(event.longitude,event.latitude);
        emit(WeatherLoaded(weather: weather));
      } catch (e) {
        emit(WeatherError(message: e.toString()));
      }
    });
    on<SelectItemEvent>((event, emit) {
      emit(ItemSelected(index: event.index));
    });

  }
}