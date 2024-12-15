class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;

  FoodCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
