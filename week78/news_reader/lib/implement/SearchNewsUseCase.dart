import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRepository.dart';
import 'package:news_reader/repository/UseCase.dart';

class SearchNewsUseCase implements UseCase<NewsResponse, String> {
  final NewsRepository repository;

  SearchNewsUseCase(this.repository);

  @override
  Future<NewsResponse> call(String query) {
    return repository.searchNews(query);
  }
}