import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorites';

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((s) => json.decode(s) as Map<String, dynamic>).toList();
  }

  static Future<void> addFavorite(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    // avoid duplicates by id+type
    final id = '${item['type']}:${item['id']}';
    final exists = list.any((s) {
      try {
        final m = json.decode(s) as Map<String, dynamic>;
        return '${m['type']}:${m['id']}' == id;
      } catch (_) {
        return false;
      }
    });
    if (!exists) {
      list.add(json.encode(item));
      await prefs.setStringList(_key, list);
    }
  }

  static Future<void> removeFavorite(String id, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.removeWhere((s) {
      try {
        final m = json.decode(s) as Map<String, dynamic>;
        return m['id'].toString() == id.toString() && m['type'] == type;
      } catch (_) {
        return false;
      }
    });
    await prefs.setStringList(_key, list);
  }

  static Future<bool> isFavorited(String id, String type) async {
    final favs = await getFavorites();
    return favs
        .any((m) => m['id'].toString() == id.toString() && m['type'] == type);
  }
}
