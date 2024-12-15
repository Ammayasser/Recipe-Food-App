import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorites';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> toggleFavorite(String recipeTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    
    if (favorites.contains(recipeTitle)) {
      favorites.remove(recipeTitle);
    } else {
      favorites.add(recipeTitle);
    }
    
    await prefs.setStringList(_key, favorites);
  }

  static Future<bool> isFavorite(String recipeTitle) async {
    final favorites = await getFavorites();
    return favorites.contains(recipeTitle);
  }
}
