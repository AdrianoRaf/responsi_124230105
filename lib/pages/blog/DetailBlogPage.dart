import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news/pages/WebViewPage.dart';

class BlogItem {
  final String id;
  final String title;
  final String? summary;
  final String? newsSite;
  final String? imageUrl;
  final String? url;
  final String? publishedAt;

  BlogItem({
    required this.id,
    required this.title,
    this.summary,
    this.newsSite,
    this.imageUrl,
    this.url,
    this.publishedAt,
  });
}

class BlogDetailPage extends StatefulWidget {
  final String blogId;

  BlogDetailPage({required this.blogId});

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  BlogItem? _blogItem;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlogDetails();
  }

  Future<void> _fetchBlogDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.spaceflightnewsapi.net/v4/blogs/${widget.blogId}'));
    if (response.statusCode == 200) {
      final blogData = jsonDecode(response.body);
      setState(() {
        _blogItem = BlogItem(
          id: blogData['id'].toString(),
          title: blogData['title'],
          summary: blogData['summary'],
          newsSite: blogData['news_site'],
          imageUrl: blogData['image_url'],
          url: blogData['url'],
          publishedAt: blogData['published_at'],
        );
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch blog details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Blog Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_blogItem?.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          _blogItem!.imageUrl!,
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (_blogItem?.imageUrl != null) SizedBox(height: 16.0),
                    Text(
                      _blogItem?.title ?? 'No Title',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _blogItem?.newsSite ?? 'No news site available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _blogItem?.publishedAt != null
                          ? DateFormat('MMMM d, yyyy')
                              .format(DateTime.parse(_blogItem!.publishedAt!))
                          : 'No published date available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _blogItem?.summary ?? 'No summary available',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: _blogItem != null && _blogItem!.url != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(_blogItem!.url!),
                  ),
                );
              },
              child: Icon(Icons.info),
            )
          : null,
    );
  }
}
