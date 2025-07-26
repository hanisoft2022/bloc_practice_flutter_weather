import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:flutter_weather/weather/widgets/weather_background.dart';
import 'package:flutter_weather/weather/widgets/weather_icon.dart';

class WeatherPopulated extends StatelessWidget {
  // final Weather weather;
  // final TemperatureUnits units;
  // final ValueGetter<Future<void>> onRefresh;

  const WeatherPopulated({
    // required this.weather,
    // required this.units,
    // required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weather = context.select((WeatherCubit cubit) => cubit.state.weather);
    final units = context.select((WeatherCubit cubit) => cubit.state.temperatureUnits);

    final theme = Theme.of(context);
    return Stack(
      children: [
        WeatherBackground(),
        RefreshIndicator(
          onRefresh: () {
            return context.read<WeatherCubit>().refreshWeather();
          },
          child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 48),
                  WeatherIcon(condition: weather.condition),
                  Text(
                    weather.location,
                    style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w200),
                  ),
                  Text(
                    weather.formattedTemperature(units),
                    style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '''Last Updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}
