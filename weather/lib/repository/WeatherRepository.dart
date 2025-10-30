import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/Location.dart';
import 'package:weather_app/model/Weather.dart';

class WeatherRepository implements IWeatherRepository {
  // Replace with your OpenWeatherMap API key
  // Get free key at: https://openweathermap.org/api
  final String apiKey = '64241cd1148c9d6c786b4293ae3734be';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  @override
  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
      '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Future<Weather> getWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$baseUrl?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}