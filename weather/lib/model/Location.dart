import 'package:weather_app/model/Weather.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}

// Repository Interfaces (SOLID - Interface Segregation)
abstract class ILocationRepository {
  Future<Location> getCurrentLocation();
}

abstract class IWeatherRepository {
  Future<Weather> getWeatherByLocation(double lat, double lon);
  Future<Weather> getWeatherByCity(String cityName);
}


