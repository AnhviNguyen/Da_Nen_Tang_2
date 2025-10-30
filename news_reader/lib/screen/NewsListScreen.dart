import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_reader/implement/GetNewsByCategoryUseCase.dart';
import 'package:news_reader/implement/GetTopHeadlinesUseCase.dart';
import 'package:news_reader/implement/NewsApiDataSource.dart';
import 'package:news_reader/implement/NewsRepositoryImpl.dart';
import 'package:news_reader/implement/SearchNewsUseCase.dart';
import 'package:news_reader/model/NewsResponse.dart';
import 'package:news_reader/repository/NewsRepository.dart';
import 'package:news_reader/screen/EmptyView.dart';
import 'package:news_reader/screen/ErrorView.dart';
import 'package:news_reader/screen/LoadingIndicator.dart';
import 'package:news_reader/screen/NewsListView.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late final NewsRepository _repository;
  late final GetTopHeadlinesUseCase _getTopHeadlinesUseCase;
  late final GetNewsByCategoryUseCase _getNewsByCategoryUseCase;
  late final SearchNewsUseCase _searchNewsUseCase;

  String _selectedCategory = 'general';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _categories = [
    'general',
    'business',
    'technology',
    'sports',
    'entertainment',
    'health',
    'science',
  ];

  @override
  void initState() {
    super.initState();
    // Replace with your actual API key from newsapi.org
    const apiKey = 'YOUR_API_KEY_HERE'; // Get from https://newsapi.org/
    final dataSource = NewsApiDataSource(apiKey: apiKey);
    _repository = NewsRepositoryImpl(dataSource);
    _getTopHeadlinesUseCase = GetTopHeadlinesUseCase(_repository);
    _getNewsByCategoryUseCase = GetNewsByCategoryUseCase(_repository);
    _searchNewsUseCase = SearchNewsUseCase(_repository);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<NewsResponse> _fetchNews() {
    if (_isSearching && _searchController.text.isNotEmpty) {
      return _searchNewsUseCase.call(_searchController.text);
    }
    return _getNewsByCategoryUseCase.call(_selectedCategory);
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {
            _onSearch(value);
          },
        )
            : const Text('News Reader'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSearching) _buildCategoryTabs(),
          Expanded(
            child: FutureBuilder<NewsResponse>(
              future: _fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }

                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: () {
                      setState(() {});
                    },
                  );
                }

                if (!snapshot.hasData || snapshot.data!.articles.isEmpty) {
                  return const EmptyView();
                }

                return NewsListView(articles: snapshot.data!.articles);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                category.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
