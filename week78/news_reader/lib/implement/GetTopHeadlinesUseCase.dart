import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRepository.dart';
import 'package:news_reader/repository/UseCase.dart';

class GetTopHeadlinesUseCase implements UseCase<NewsResponse, String> {
  final NewsRepository repository;

  GetTopHeadlinesUseCase(this.repository);

  @override
  Future<NewsResponse> call(String country) {
    return repository.getTopHeadlines(country: country);
  }
}