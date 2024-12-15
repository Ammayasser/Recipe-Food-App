import '../models/food_category.dart';
import '../models/recipe.dart';

class FoodService {
  static final FoodService _instance = FoodService._internal();
  factory FoodService() => _instance;
  FoodService._internal();

  Future<List<FoodCategory>> getFoodCategories() async {
    // Debug print to check the categories being created
    print('Creating food categories...');
    final categories = [
      FoodCategory(
        id: '1',
        name: 'Chicken',
        imageUrl: 'images/Chicken.jpg',
      ),
      FoodCategory(
        id: '2',
        name: 'Beef',
        imageUrl: 'images/beef.jpg',
      ),
      FoodCategory(
        id: '3',
        name: 'Fish',
        imageUrl: 'images/fish.jpg',
      ),
      FoodCategory(
        id: '4',
        name: 'Pork',
        imageUrl: 'images/pork.jpg',
      ),
      FoodCategory(
        id: '5',
        name: 'Seafood',
        imageUrl: 'images/seafood.jpg',
      ),
      FoodCategory(
        id: '6',
        name: 'Duck',
        imageUrl: 'images/duck.jpg',
      ),
      FoodCategory(
        id: '7',
        name: 'Lamb',
        imageUrl: 'images/lamp (2).jpg',
      ),
      FoodCategory(
        id: '8',
        name: 'Turkey',
        imageUrl: 'images/turkey.jpg',
      ),
    ];

    // Debug print to check image paths
    for (var category in categories) {
      print('Category: ${category.name}, Image path: ${category.imageUrl}');
    }

    return categories;
  }

  Future<List<Recipe>> getLatestRecipes() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulating API delay
    return [
      Recipe(
        name: 'Classic Chicken Curry',
        imageUrl: 'images/Chicken.jpg',
        description: 'A delicious and aromatic chicken curry',
        cookingTime: '45 mins',
        servings: '4',
      ),
      Recipe(
        name: 'Grilled Beef Steak',
        imageUrl: 'images/beef.jpg',
        description: 'Perfectly grilled beef steak with herbs',
        cookingTime: '30 mins',
        servings: '2',
      ),
      Recipe(
        name: 'Steamed Fish',
        imageUrl: 'images/fish.jpg',
        description: 'Healthy steamed fish with ginger and soy',
        cookingTime: '25 mins',
        servings: '3',
      ),
    ];
  }
}
