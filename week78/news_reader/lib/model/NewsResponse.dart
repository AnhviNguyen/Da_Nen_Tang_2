import 'package:news_reader/model/Article.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] ?? 'error',
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List<dynamic>?)
          ?.map((article) => Article.fromJson(article))
          .toList() ??
          [],
    );
  }
}