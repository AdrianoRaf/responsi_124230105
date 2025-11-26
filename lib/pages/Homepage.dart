import 'package:flutter/material.dart';
import 'package:news/pages/blog/BlogPage.dart';
import 'package:news/pages/news/NewsPage.dart';
import 'package:news/pages/report/ReportPage.dart';
import 'package:news/pages/favorit.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _homePressed = false;
  bool _favPressed = false;
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'News',
      'icon': Icons.newspaper,
      'description':
          'Get an overview of the latest SpaceFlight news, from various sources. Easily link your users to the right websites.',
      'route': NewsListPage(),
    },
    {
      'title': 'Blog',
      'icon': Icons.comment,
      'description':
          'Blogs often provide a more detailed overview of launches and missions. A must-have for the serious spaceflight enthusiast.',
      'route': BlogListPage(),
    },
    {
      'title': 'Report',
      'icon': Icons.assessment,
      'description':
          'Space stations and other missions often publish their data. With SNAP!, you can include it in your app.',
      'route': ReportListPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Selamat Datang, ${widget.username}!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: menuItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.0),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['route']),
                );
              },
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(item['icon'], size: 48),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['description'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapDown: (_) => setState(() => _homePressed = true),
                onTapUp: (_) {
                  Future.delayed(Duration(milliseconds: 180),
                      () => setState(() => _homePressed = false));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                onTapCancel: () => setState(() => _homePressed = false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.home,
                    color: _homePressed ? Colors.blue : Colors.black54,
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) => setState(() => _favPressed = true),
                onTapUp: (_) {
                  Future.delayed(Duration(milliseconds: 180),
                      () => setState(() => _favPressed = false));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()),
                  );
                },
                onTapCancel: () => setState(() => _favPressed = false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite,
                    color: _favPressed ? Colors.red : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
