import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_reader/model/Article.dart';
import 'package:news_reader/screen/ArticleDetailScreen.dart';
import 'package:news_reader/screen/NewsCard.dart';

class NewsListView extends StatelessWidget {
  final List<Article> articles;

  const NewsListView({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger rebuild
        (context as Element).markNeedsBuild();
      },
      child: ListView.builder(
        itemCount: articles.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return NewsCard(
            article: articles[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(
                    article: articles[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
