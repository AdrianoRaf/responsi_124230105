import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NewsDetailPage.dart';
import 'package:news/util/FavoriteService.dart';
import 'package:intl/intl.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<dynamic> newsArticles = [];
  bool isLoading = true;
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          newsArticles = data['results'];
          isLoading = false;
        });
        _loadFavorites();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch news articles')),
      );
    }
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoriteService.getFavorites();
    setState(() {
      _favoriteIds = favs
          .where((m) => m['type'] == 'news')
          .map((m) => m['id'].toString())
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Berita Terkini'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: newsArticles.length,
                itemBuilder: (context, index) {
                    final article = newsArticles[index];
                    final publishedDate = DateTime.parse(article['published_at']);
                    final formattedDate = DateFormat('MMMM d, yyyy').format(publishedDate);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(article['id']),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8.0)),
                                child: Image.network(
                                  article['image_url'] ??
                                      'https://via.placeholder.com/100x150',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                  icon: Icon(
                                    _favoriteIds.contains(article['id'].toString())
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favoriteIds.contains(article['id'].toString())
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: () async {
                                    final idStr = article['id'].toString();
                                    if (_favoriteIds.contains(idStr)) {
                                      await FavoriteService.removeFavorite(idStr, 'news');
                                    } else {
                                      final item = {
                                        'id': article['id'].toString(),
                                        'type': 'news',
                                        'title': article['title'],
                                        'image_url': article['image_url'],
                                        'news_site': article['news_site'],
                                        'summary': article['summary'],
                                        'url': article['url'],
                                      };
                                      await FavoriteService.addFavorite(item);
                                    }
                                    _loadFavorites();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      article['news_site'] ??
                                          'No news site available',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(height: 8.0),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
