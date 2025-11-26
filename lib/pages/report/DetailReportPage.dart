import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news/pages/WebViewPage.dart';

class ReportDetailPage extends StatefulWidget {
  final String reportId;

  ReportDetailPage(reportId)
      : this.reportId = reportId == null ? '' : reportId.toString();

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  Map<String, dynamic>? _report;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportDetails();
  }

  Future<void> _fetchReportDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.spaceflightnewsapi.net/v4/reports/${widget.reportId}'));
      if (response.statusCode == 200) {
        setState(() {
          _report = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load report details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch report details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Report Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_report?['image_url'] != null)
                      Image.network(
                        _report!['image_url'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    if (_report?['image_url'] != null) SizedBox(height: 16.0),
                    Text(
                      _report?['title'] ?? 'No Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _report?['news_site'] ?? 'No news site available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _report?['published_at'] != null
                          ? DateFormat('MMMM d, yyyy')
                              .format(DateTime.parse(_report!['published_at']))
                          : 'No published date available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      _report?['summary'] ?? 'No summary available',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: _report != null && _report!['url'] != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(_report!['url']),
                  ),
                );
              },
              child: Icon(Icons.info),
            )
          : null,
    );
  }
}
