import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/implement/GetCurrentLocationWeatherUseCase.dart';
import 'package:weather_app/implement/GetWeatherByCityUseCase.dart';
import 'package:weather_app/provider/WeatherProvider.dart';
import 'package:weather_app/repository/LocationRepository.dart';
import 'package:weather_app/repository/WeatherRepository.dart';
import 'package:weather_app/screen/WeatherScreen.dart';

void main() {
  // Dependency Injection (SOLID - Dependency Inversion)
  final locationRepository = LocationRepository();
  final weatherRepository = WeatherRepository();

  final getCurrentLocationWeatherUseCase = GetCurrentLocationWeatherUseCase(
    locationRepository: locationRepository,
    weatherRepository: weatherRepository,
  );

  final getWeatherByCityUseCase = GetWeatherByCityUseCase(weatherRepository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(
        getCurrentLocationWeatherUseCase: getCurrentLocationWeatherUseCase,
        getWeatherByCityUseCase: getWeatherByCityUseCase,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}