import 'package:flutter/cupertino.dart';
import 'package:weather_app/implement/GetCurrentLocationWeatherUseCase.dart';
import 'package:weather_app/implement/GetWeatherByCityUseCase.dart';
import 'package:weather_app/model/Weather.dart';

class WeatherProvider extends ChangeNotifier {
  final GetCurrentLocationWeatherUseCase getCurrentLocationWeatherUseCase;
  final GetWeatherByCityUseCase  getWeatherByCityUseCase;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherProvider({
    required this.getCurrentLocationWeatherUseCase,
    required this.getWeatherByCityUseCase,
  });

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentLocationWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await getCurrentLocationWeatherUseCase.execute();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWeatherByCity(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await getWeatherByCityUseCase.execute(cityName);
      _error = null;
    } catch (e) {
      _error = 'City not found or network error';
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
