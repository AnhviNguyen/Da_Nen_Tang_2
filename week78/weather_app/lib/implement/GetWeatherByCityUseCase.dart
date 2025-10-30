import 'package:weather_app/model/Location.dart';
import 'package:weather_app/model/Weather.dart';

class GetWeatherByCityUseCase {
  final IWeatherRepository weatherRepository;

  GetWeatherByCityUseCase(this.weatherRepository);

  Future<Weather> execute(String cityName) async {
    return await weatherRepository.getWeatherByCity(cityName);
  }
}