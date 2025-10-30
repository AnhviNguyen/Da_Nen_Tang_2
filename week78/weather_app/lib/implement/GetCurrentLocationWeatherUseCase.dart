import 'package:weather_app/model/Location.dart';
import 'package:weather_app/model/Weather.dart';

class GetCurrentLocationWeatherUseCase {
  final ILocationRepository locationRepository;
  final IWeatherRepository weatherRepository;

  GetCurrentLocationWeatherUseCase({
    required this.locationRepository,
    required this.weatherRepository,
  });

  Future<Weather> execute() async {
    final location = await locationRepository.getCurrentLocation();
    return await weatherRepository.getWeatherByLocation(
      location.latitude,
      location.longitude,
    );
  }
}