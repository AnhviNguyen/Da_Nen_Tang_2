import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRemoteDataSource.dart';
import 'package:news_reader/repository/NewsRepository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<NewsResponse> getTopHeadlines({String country = 'us'}) {
    return remoteDataSource.fetchTopHeadlines(country);
  }

  @override
  Future<NewsResponse> searchNews(String query) {
    return remoteDataSource.fetchNewsByQuery(query);
  }

  @override
  Future<NewsResponse> getNewsByCategory(String category) {
    return remoteDataSource.fetchNewsByCategory(category);
  }
}