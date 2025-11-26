import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<Map<String, dynamic>> fetchNewsDetails(int newsId) async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/$newsId/'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load news details');
    }
  }

  static Future<List<dynamic>> fetchBlogs() async {
    final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/blogs/'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  static Future<Map<String, dynamic>> fetchBlogDetails(int blogId) async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/blogs/$blogId/'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load blog details');
    }
  }

  static Future<List<dynamic>> fetchReports() async {
    final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/reports/'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load reports');
    }
  }

  static Future<Map<String, dynamic>> fetchReportDetails(int reportId) async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/reports/$reportId/'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load report details');
    }
  }
  void loadArticles() async {
    try {
      List<dynamic> articles = await ApiClient.fetchNews();
      print('Daftar Artikel: $articles');
    } catch (e) {
      print('Kesalahan saat memuat artikel: $e');
    }
  }

  void loadBlogDetails(int blogId) async {
    try {
      Map<String, dynamic> blogDetails = await ApiClient.fetchBlogDetails(blogId);
      print('Detail Blog: $blogDetails');
    } catch (e) {
      print('Kesalahan saat memuat detail blog: $e');
    }
  }

  void loadReports() async {
    try {
      List<dynamic> reports = await ApiClient.fetchReports();
      print('Daftar Laporan: $reports');
    } catch (e) {
      print('Kesalahan saat memuat laporan: $e');
    }
  }
}
