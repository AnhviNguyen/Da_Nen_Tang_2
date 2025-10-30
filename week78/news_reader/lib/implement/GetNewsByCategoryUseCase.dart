import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRepository.dart';
import 'package:news_reader/repository/UseCase.dart';

class GetNewsByCategoryUseCase implements UseCase<NewsResponse, String> {
  final NewsRepository repository;

  GetNewsByCategoryUseCase(this.repository);

  @override
  Future<NewsResponse> call(String category) {
    return repository.getNewsByCategory(category);
  }
}
