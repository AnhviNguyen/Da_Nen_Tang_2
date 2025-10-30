import 'package:news_reader/model/NewsResponse.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponse> fetchTopHeadlines(String country);
  Future<NewsResponse> fetchNewsByQuery(String query);
  Future<NewsResponse> fetchNewsByCategory(String category);
}