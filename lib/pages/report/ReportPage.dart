import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/pages/report/DetailReportPage.dart';
import 'package:news/util/FavoriteService.dart';
import 'package:intl/intl.dart';

class ReportListPage extends StatefulWidget {
  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  List<dynamic> reports = [];
  bool isLoading = true;
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.spaceflightnewsapi.net/v4/reports/'));
      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> data = json.decode(response.body);
          reports = data['results'];
          isLoading = false;
        });
        _loadFavorites();
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch reports')),
      );
    }
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoriteService.getFavorites();
    setState(() {
      _favoriteIds = favs
          .where((m) => m['type'] == 'report')
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
        title: Text('Reports'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final publishedDate = DateTime.parse(report['published_at']);
                  final formattedDate =
                      DateFormat('MMMM d, yyyy').format(publishedDate);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDetailPage(report['id']),
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
                                  report['image_url'] ??
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
                                    _favoriteIds
                                            .contains(report['id'].toString())
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favoriteIds
                                            .contains(report['id'].toString())
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: () async {
                                    final idStr = report['id'].toString();
                                    if (_favoriteIds.contains(idStr)) {
                                      await FavoriteService.removeFavorite(
                                          idStr, 'report');
                                    } else {
                                      final item = {
                                        'id': report['id'].toString(),
                                        'type': 'report',
                                        'title': report['title'],
                                        'image_url': report['image_url'],
                                        'news_site': report['news_site'],
                                        'summary': report['summary'],
                                        'url': report['url'],
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
                                  report['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      report['news_site'] ??
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
