import 'package:flutter/material.dart';

class Recipe {
  final String name;
  final String imageUrl;
  final String description;
  final String cookingTime;
  final String servings;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.cookingTime,
    required this.servings,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      cookingTime: json['cookingTime'] ?? '',
      servings: json['servings'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
