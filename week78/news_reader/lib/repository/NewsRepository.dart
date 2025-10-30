import 'package:news_reader/model/NewsResponse.dart';

abstract class NewsRepository {
  Future<NewsResponse> getTopHeadlines({String country = 'us'});
  Future<NewsResponse> searchNews(String query);
  Future<NewsResponse> getNewsByCategory(String category);
}