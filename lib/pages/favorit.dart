import 'package:flutter/material.dart';
import 'package:news/util/FavoriteService.dart';
import 'package:news/pages/news/NewsDetailPage.dart';
import 'package:news/pages/blog/DetailBlogPage.dart';
import 'package:news/pages/report/DetailReportPage.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favs = await FavoriteService.getFavorites();
    setState(() {
      _favorites = favs;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String id, String type) async {
    await FavoriteService.removeFavorite(id, type);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed from favorites')),
    );
    _loadFavorites();
  }

  void _openDetail(Map<String, dynamic> item) {
    final type = item['type'];
    final id = item['id'].toString();
    if (type == 'news') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsDetailPage(int.parse(id))),
      );
    } else if (type == 'blog') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlogDetailPage(blogId: id)),
      );
    } else if (type == 'report') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportDetailPage(id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit Saya'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? Center(child: Text('Belum ada favorit'))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final item = _favorites[index];
                    return Dismissible(
                      key: Key('${item['type']}:${item['id']}'),
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) {
                        _removeFavorite(item['id'].toString(), item['type']);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: item['image_url'] != null
                            ? Image.network(
                                item['image_url'],
                                width: 72,
                                fit: BoxFit.cover,
                              )
                            : SizedBox(width: 72),
                        title: Text(item['title'] ?? ''),
                        subtitle: Text(item['news_site'] ?? item['type']),
                        onTap: () => _openDetail(item),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // Refresh favorites or indicate current
                  _loadFavorites();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Daftar favorit diperbarui')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
