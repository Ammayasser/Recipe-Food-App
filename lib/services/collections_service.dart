import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeCollection {
  final String name;
  final String description;
  final List<String> recipeTitles;
  final DateTime createdAt;

  RecipeCollection({
    required this.name,
    required this.description,
    required this.recipeTitles,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'recipeTitles': recipeTitles,
        'createdAt': createdAt.toIso8601String(),
      };

  factory RecipeCollection.fromJson(Map<String, dynamic> json) {
    return RecipeCollection(
      name: json['name'],
      description: json['description'],
      recipeTitles: List<String>.from(json['recipeTitles']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CollectionsService {
  static const String _key = 'recipe_collections';

  static Future<List<RecipeCollection>> getCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final String? collectionsJson = prefs.getString(_key);
    if (collectionsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(collectionsJson);
    return decoded.map((item) => RecipeCollection.fromJson(item)).toList();
  }

  static Future<void> saveCollection(RecipeCollection collection) async {
    final prefs = await SharedPreferences.getInstance();
    final collections = await getCollections();

    collections.removeWhere((c) => c.name == collection.name);
    collections.add(collection);

    final encoded = jsonEncode(collections.map((c) => c.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> deleteCollection(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final collections = await getCollections();
    collections.removeWhere((c) => c.name == name);

    final encoded = jsonEncode(collections.map((c) => c.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
