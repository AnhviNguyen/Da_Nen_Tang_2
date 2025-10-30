import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRemoteDataSource.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApiDataSource implements NewsRemoteDataSource {
  final String apiKey;
  final String baseUrl = 'https://newsapi.org/v2';

  NewsApiDataSource({required this.apiKey});

  @override
  Future<NewsResponse> fetchTopHeadlines(String country) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<NewsResponse> fetchNewsByQuery(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<NewsResponse> fetchNewsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?category=$category&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return NewsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load category news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}