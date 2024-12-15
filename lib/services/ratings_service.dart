import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeReview {
  final String recipeTitle;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> images; // Optional: Allow users to add photos to reviews

  RecipeReview({
    required this.recipeTitle,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
  });

  Map<String, dynamic> toJson() => {
    'recipeTitle': recipeTitle,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
    'images': images,
  };

  factory RecipeReview.fromJson(Map<String, dynamic> json) {
    return RecipeReview(
      recipeTitle: json['recipeTitle'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      images: List<String>.from(json['images']),
    );
  }
}

class RatingsService {
  static const String _key = 'recipe_ratings';

  static Future<List<RecipeReview>> getReviews(String recipeTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final String? reviewsJson = prefs.getString(_key);
    if (reviewsJson == null) return [];

    final List<dynamic> decoded = jsonDecode(reviewsJson);
    final reviews = decoded
        .map((item) => RecipeReview.fromJson(item))
        .where((review) => review.recipeTitle == recipeTitle)
        .toList();
    
    // Sort by most recent
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  static Future<double> getAverageRating(String recipeTitle) async {
    final reviews = await getReviews(recipeTitle);
    if (reviews.isEmpty) return 0.0;
    
    final sum = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  static Future<void> addReview(RecipeReview review) async {
    final prefs = await SharedPreferences.getInstance();
    final String? reviewsJson = prefs.getString(_key);
    final List<RecipeReview> reviews = [];
    
    if (reviewsJson != null) {
      final List<dynamic> decoded = jsonDecode(reviewsJson);
      reviews.addAll(decoded.map((item) => RecipeReview.fromJson(item)));
    }
    
    reviews.add(review);
    final encoded = jsonEncode(reviews.map((r) => r.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> deleteReview(String recipeTitle, DateTime createdAt) async {
    final prefs = await SharedPreferences.getInstance();
    final String? reviewsJson = prefs.getString(_key);
    if (reviewsJson == null) return;

    final List<dynamic> decoded = jsonDecode(reviewsJson);
    final reviews = decoded
        .map((item) => RecipeReview.fromJson(item))
        .where((review) => 
            !(review.recipeTitle == recipeTitle && 
              review.createdAt.isAtSameMomentAs(createdAt)))
        .toList();

    final encoded = jsonEncode(reviews.map((r) => r.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
