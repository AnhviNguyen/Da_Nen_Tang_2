class Article {
  final String title;
  final String description;
  final String content;
  final String url;
  final String? urlToImage;
  final String? author;
  final String publishedAt;
  final String? sourceName;

  const Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    this.urlToImage,
    this.author,
    required this.publishedAt,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      author: json['author'],
      publishedAt: json['publishedAt'] ?? '',
      sourceName: json['source']?['name'],
    );
  }
}