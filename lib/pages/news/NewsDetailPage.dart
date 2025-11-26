import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../WebViewPage.dart';

class NewsDetailPage extends StatefulWidget {
  final int newsId;

  NewsDetailPage(this.newsId);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Map<String, dynamic>? _newsDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNewsDetails();
  }

  Future<void> _fetchNewsDetails() async {
    final response = await http.get(Uri.parse(
        'https://api.spaceflightnewsapi.net/v4/articles/${widget.newsId}'));
    if (response.statusCode == 200) {
      setState(() {
        _newsDetails = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch news details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('News Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        _newsDetails?['image_url'] ??
                            'https://via.placeholder.com/200',
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _newsDetails?['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _newsDetails?['news_site'] ?? 'No news site available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      DateFormat('MMMM d, yyyy').format(
                        DateTime.parse(_newsDetails?['published_at'] ?? ''),
                      ),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _newsDetails?['summary'] ?? 'No summary available',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: _newsDetails != null && _newsDetails!['url'] != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(_newsDetails!['url']),
                  ),
                );
              },
              child: Icon(Icons.info),
            )
          : null,
    );
  }
}
