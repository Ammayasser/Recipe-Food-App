import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'recipe_detail_screen.dart';
import 'category_details_screen.dart';
import '../widgets/animated_button.dart';
import '../widgets/category_card.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/user_header.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'favorites_screen.dart'; // Add this line
import 'profile_screen.dart'; // Add this line
import '../services/favorites_service.dart';

class CategoryItem {
  final String name;
  final String image;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  CategoryItem({
    required this.name,
    required this.image,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });
}

class Recipe {
  final String title;
  final String description;
  final String image;
  final String time;
  final Color bgColor;
  final String lessons;
  bool isFavorite;
  final List<String> ingredients;
  final List<String> instructions;
  final String difficulty;
  final String servings;
  final Map<String, String> nutritionInfo;
  double? averageRating;
  int reviewCount;
  final List<String> tags;
  final bool isPremium;

  Recipe({
    required this.title,
    required this.description,
    required this.image,
    required this.time,
    required this.bgColor,
    this.lessons = '2',
    this.isFavorite = false,
    this.ingredients = const [],
    this.instructions = const [],
    this.difficulty = 'Medium',
    this.servings = '4',
    this.nutritionInfo = const {},
    this.averageRating,
    this.reviewCount = 0,
    this.tags = const [],
    this.isPremium = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  List<Recipe> recipes = [];
  Set<String> favoriteRecipes = {}; // Add this line to track favorite recipes
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Breakfast',
      image:
          'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      bgColor: const Color(0xFFFFE8E0),
      textColor: const Color.fromARGB(255, 145, 61, 255),
      icon: Icons.breakfast_dining,
    ),
    CategoryItem(
      name: 'Main Course',
      image:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      bgColor: const Color(0xFFE6F5E6),
      textColor: const Color(0xFF2FB344),
      icon: Icons.restaurant,
    ),
    CategoryItem(
      name: 'Desserts',
      image:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      bgColor: const Color(0xFFFFF0F0),
      textColor: const Color(0xFFFF4B4B),
      icon: Icons.cake,
    ),
    CategoryItem(
      name: 'Drinks',
      image:
          'https://images.unsplash.com/photo-1613478223719-2ab802602423?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      bgColor: const Color(0xFFE6F0FF),
      textColor: const Color(0xFF3B82F6),
      icon: Icons.local_drink,
    ),
    CategoryItem(
      name: 'Healthy',
      image:
          'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      bgColor: const Color(0xFFF0FFF4),
      textColor: const Color(0xFF10B981),
      icon: Icons.eco,
    ),
    CategoryItem(
      name: 'Gym & Fitness',
      image:
          'https://media.istockphoto.com/id/1423997728/photo/top-view-asian-man-and-woman-healthy-eating-salad-after-exercise-at-fitness-gym.webp?a=1&b=1&s=612x612&w=0&k=20&c=jafyhCN-NWNMEdVS_nS_fcA5lz6Iv2AygqEzn3vgSZY=',
      bgColor: const Color(0xFFE7F0FF),
      textColor: const Color(0xFF4B6BFB),
      icon: Icons.fitness_center,
    ),
  ];

  final List<Recipe> recipesList = [
    // Breakfast Recipes
    Recipe(
      title: 'Fluffy Pancakes',
      lessons: '3 lessons',
      time: '20 min',
      bgColor: Colors.amber.shade200,
      image:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
      description:
          'Start your morning with delicious fluffy pancakes served with maple syrup and fresh berries.',
    ),
    Recipe(
      title: 'Avocado Toast',
      lessons: '2 lessons',
      time: '15 min',
      bgColor: Colors.green.shade200,
      image:
          'https://images.unsplash.com/photo-1588137378633-dea1336ce1e2?w=800',
      description:
          'Healthy breakfast option with mashed avocado on toasted bread, topped with eggs and seeds.',
    ),
    Recipe(
      title: 'English Breakfast',
      lessons: '4 lessons',
      time: '25 min',
      bgColor: Colors.red.shade200,
      image:
          'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=800',
      description:
          'Traditional English breakfast with eggs, bacon, beans, and toast. Perfect morning energy boost.',
    ),
    Recipe(
      title: 'French Toast',
      lessons: '3 lessons',
      time: '18 min',
      bgColor: Colors.brown.shade200,
      image:
          'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800',
      description:
          'Classic French toast with cinnamon, vanilla, and maple syrup. Topped with fresh fruits.',
    ),
    Recipe(
      title: 'Breakfast Burrito',
      lessons: '4 lessons',
      time: '22 min',
      bgColor: Colors.orange.shade200,
      image:
          'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=800',
      description:
          'Hearty breakfast burrito filled with eggs, cheese, potatoes, and your choice of protein.',
    ),
    Recipe(
      title: 'Oatmeal Bowl',
      lessons: '2 lessons',
      time: '12 min',
      bgColor: Colors.amber.shade100,
      image:
          'https://plus.unsplash.com/premium_photo-1675013208584-e3617fdd930b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8b2F0bWVhbCUyMGJvd2x8ZW58MHx8MHx8fDA%3D',
      description:
          'Healthy oatmeal bowl with nuts, seeds, fruits, and a drizzle of honey.',
    ),

    // Dessert Recipes
    Recipe(
      title: 'Chocolate Cake',
      lessons: '5 lessons',
      time: '45 min',
      bgColor: Colors.brown.shade200,
      image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      description:
          'Rich and moist chocolate cake with smooth chocolate ganache frosting.',
    ),
    Recipe(
      title: 'Berry Cheesecake',
      lessons: '4 lessons',
      time: '60 min',
      bgColor: Colors.purple.shade200,
      image:
          'https://images.unsplash.com/photo-1675540212407-a67ab877c418?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      description:
          'Creamy cheesecake topped with fresh mixed berries and a sweet berry compote.',
    ),
    Recipe(
      title: 'Apple Pie',
      lessons: '6 lessons',
      time: '75 min',
      bgColor: Colors.orange.shade200,
      image:
          'https://images.unsplash.com/photo-1535920527002-b35e96722eb9?w=800',
      description:
          'Classic homemade apple pie with a flaky crust and cinnamon-spiced filling.',
    ),
    Recipe(
      title: 'Tiramisu',
      lessons: '5 lessons',
      time: '40 min',
      bgColor: Colors.brown.shade100,
      image:
          'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800',
      description:
          'Italian dessert with coffee-soaked ladyfingers and mascarpone cream.',
    ),
    Recipe(
      title: 'Crème Brûlée',
      lessons: '4 lessons',
      time: '55 min',
      bgColor: Colors.amber.shade100,
      image:
          'https://images.unsplash.com/photo-1676300184943-09b2a08319a3?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fENyJUMzJUE4bWUlMjBCciVDMyVCQmwlQzMlQTllfGVufDB8fDB8fHww',
      description:
          'Classic French dessert with rich vanilla custard and caramelized sugar top.',
    ),
    Recipe(
      title: 'Fruit Tart',
      lessons: '5 lessons',
      time: '50 min',
      bgColor: Colors.pink.shade100,
      image:
          'https://images.unsplash.com/photo-1519915028121-7d3463d20b13?w=800',
      description:
          'Beautiful fruit tart with pastry cream and fresh seasonal fruits.',
    ),

    // Drinks Recipes
    Recipe(
      title: 'Fruit Smoothie',
      lessons: '2 lessons',
      time: '10 min',
      bgColor: Colors.pink.shade200,
      image:
          'https://plus.unsplash.com/premium_photo-1681826664053-5f50e4a0c513?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZnJ1aXQlMjBzbW9vdGhpZXxlbnwwfHwwfHx8MA%3D%3D',
      description:
          'Refreshing mixed berry and banana smoothie packed with vitamins.',
    ),
    Recipe(
      title: 'Iced Latte',
      lessons: '3 lessons',
      time: '15 min',
      bgColor: Colors.brown.shade200,
      image:
          'https://images.unsplash.com/photo-1517640111823-61075694e5ba?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGljZWQlMjBsYXR0ZXxlbnwwfHwwfHx8MA%3D%3D',
      description: 'Perfect cold coffee drink with espresso and cold milk.',
    ),
    Recipe(
      title: 'Tropical Punch',
      lessons: '3 lessons',
      time: '12 min',
      bgColor: Colors.orange.shade200,
      image:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800',
      description:
          'A refreshing blend of tropical fruits with coconut water and mint.',
    ),
    Recipe(
      title: 'Matcha Latte',
      lessons: '3 lessons',
      time: '8 min',
      bgColor: Colors.green.shade200,
      image:
          'https://media.istockphoto.com/id/1356367782/photo/delicious-vegan-matcha-ice-latte-in-glass.webp?a=1&b=1&s=612x612&w=0&k=20&c=CHWsMOW237iZcFuHwyoWhyKdPQzCv3agGhNs8eQghh8=',
      description: 'Japanese-inspired green tea latte with frothed milk.',
    ),
    Recipe(
      title: 'Mojito Mocktail',
      lessons: '3 lessons',
      time: '10 min',
      bgColor: Colors.green.shade100,
      image: 'https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=800',
      description:
          'Refreshing non-alcoholic mojito with lime, mint, and sparkling water.',
    ),
    Recipe(
      title: 'Hot Chocolate',
      lessons: '2 lessons',
      time: '12 min',
      bgColor: Colors.brown.shade100,
      image:
          'https://images.unsplash.com/photo-1517578239113-b03992dcdd25?w=800',
      description:
          'Rich and creamy hot chocolate topped with whipped cream and marshmallows.',
    ),

    // Main Course Recipes
    Recipe(
      title: 'Chinese Vegetable Stir-Fry',
      lessons: '5 lessons',
      time: '30 min',
      bgColor: Colors.teal.shade200,
      image:
          'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
      description: 'Healthy stir-fried vegetables with garlic sauce.',
    ),
    Recipe(
      title: 'Grilled Beef Steak',
      lessons: '4 lessons',
      time: '35 min',
      bgColor: Colors.red.shade200,
      image:
          'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800',
      description: 'Perfect steak with herb butter and roasted vegetables.',
    ),
    Recipe(
      title: 'Seafood Pasta',
      lessons: '6 lessons',
      time: '45 min',
      bgColor: Colors.blue.shade200,
      image:
          'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=800',
      description: 'Creamy pasta with shrimp, mussels, and white wine sauce.',
    ),
    Recipe(
      title: 'Chicken Curry',
      lessons: '5 lessons',
      time: '40 min',
      bgColor: Colors.orange.shade200,
      image:
          'https://images.unsplash.com/photo-1672933036331-e27ffae157bd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Q2hpY2tlbiUyMEN1cnJ5fGVufDB8fDB8fHww',
      description: 'Rich and aromatic chicken curry with basmati rice.',
    ),
    Recipe(
      title: 'Margherita Pizza',
      lessons: '4 lessons',
      time: '35 min',
      bgColor: Colors.red.shade100,
      image:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
      description:
          'Classic pizza with tomato sauce, fresh mozzarella, and basil.',
    ),
    Recipe(
      title: 'Salmon Teriyaki',
      lessons: '4 lessons',
      time: '25 min',
      bgColor: Colors.pink.shade100,
      image:
          'https://images.unsplash.com/photo-1580476262798-bddd9f4b7369?w=800',
      description: 'Glazed salmon with teriyaki sauce and steamed vegetables.',
    ),

    // Healthy Recipes
    Recipe(
      title: 'Quinoa Buddha Bowl',
      lessons: '3 lessons',
      time: '25 min',
      bgColor: Colors.green.shade100,
      image:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      description:
          'Nutritious bowl with quinoa, roasted vegetables, and tahini dressing.',
    ),
    Recipe(
      title: 'Greek Salad',
      lessons: '2 lessons',
      time: '15 min',
      bgColor: Colors.blue.shade100,
      image:
          'https://images.unsplash.com/photo-1659270157105-39249fb062ee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8R3JlZWklMjBTYWxhZHxlbnwwfHwwfHx8MA%3D%3D',
      description: 'Fresh Mediterranean salad with feta cheese and olives.',
    ),
    Recipe(
      title: 'Grilled Chicken Salad',
      lessons: '3 lessons',
      time: '20 min',
      bgColor: Colors.yellow.shade100,
      image:
          'https://plus.unsplash.com/premium_photo-1673590981810-894dadc93a6d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8R3JpbGxlZCUyMENoaWNrZW4lMjBTYWxhZHxlbnwwfHwwfHx8MA%3D%3D',
      description:
          'Healthy grilled chicken salad with mixed greens and avocado.',
    ),

    // Gym & Fitness Recipes
    Recipe(
      title: 'Pre-Workout Meal',
      lessons: '2 lessons',
      time: '15 min',
      bgColor: Colors.blue.shade200,
      image:
          'https://images.unsplash.com/photo-1633339409275-84fb9541ab88?w=800',
      description:
          'Perfect pre-workout meal with complex carbs and protein. Includes oats, banana, and whey protein shake.',
      tags: ['Pre Workout', 'Energy', 'Protein'],
      nutritionInfo: {
        'Protein': '25g',
        'Carbs': '40g',
        'Fat': '8g',
        'Calories': '350',
      },
    ),
    Recipe(
      title: 'Post-Workout Protein Stack',
      lessons: '2 lessons',
      time: '10 min',
      bgColor: Colors.purple.shade200,
      image:
          'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=800',
      description:
          'Quick post-workout protein stack with grilled chicken breast, eggs, and protein shake. Optimal for muscle recovery.',
      tags: ['Post Workout', 'High Protein', 'Recovery'],
      nutritionInfo: {
        'Protein': '45g',
        'Carbs': '20g',
        'Fat': '10g',
        'Calories': '380',
      },
    ),
    Recipe(
      title: 'Bodybuilder\'s Meal Prep',
      lessons: '3 lessons',
      time: '30 min',
      bgColor: Colors.teal.shade200,
      image: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=800',
      description:
          'High-protein meal prep with lean chicken, brown rice, and broccoli. Perfect for muscle building and maintenance.',
      tags: ['Meal Prep', 'Muscle Gain', 'Bulk'],
      nutritionInfo: {
        'Protein': '50g',
        'Carbs': '60g',
        'Fat': '15g',
        'Calories': '580',
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadFavorites();
    _filteredRecipes = recipesList;
    _searchController.addListener(_onSearchChanged);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error =
            'Failed to load data. Please check your internet connection and try again.';
      });
    }
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesService.getFavorites();
    setState(() {
      for (var recipe in recipesList) {
        recipe.isFavorite = favorites.contains(recipe.title);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = recipesList
          .where((recipe) =>
              recipe.title.toLowerCase().contains(searchTerm) ||
              recipe.description.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.forward(from: 0);
  }

  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildFavoritesContent();
      case 2:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading recipes...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const UserHeader(),
          const SizedBox(height: 16),
          RecipeSearchBar(
            controller: _searchController,
            onSubmitted: (value) {
              if (_filteredRecipes.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(
                      title: _filteredRecipes.first.title,
                      image: _filteredRecipes.first.image,
                      time: _filteredRecipes.first.time,
                      description: _filteredRecipes.first.description,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Categories',
            onSeeAllPressed: () => _showAllCategories(context),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Popular Recipes',
            onSeeAllPressed: () => _showAllRecipes(context),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredRecipes.length,
            itemBuilder: (context, index) {
              return _buildRecipeCard(_filteredRecipes[index], context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return FavoritesScreen(recipesList: recipesList);
  }

  Widget _buildProfileContent() {
    return const ProfileScreen();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildCategoryCard(CategoryItem category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailsScreen(
                category: category,
                recipes: recipesList,
              ),
            ),
          );
        },
        splashColor: category.bgColor.withOpacity(0.2),
        child: SizedBox(
          width: 100,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                    height: 70,
                    width: 70,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: category.textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFavorite(Recipe recipe) async {
    await FavoritesService.toggleFavorite(recipe.title);
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
      _filteredRecipes = List.from(recipesList);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          recipe.isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showAllCategories(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            // Grid of categories
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            category: category,
                            recipes: recipesList,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              category.image,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllRecipes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'All Recipes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            // Grid of recipes
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: recipesList.length,
                itemBuilder: (context, index) {
                  final recipe = recipesList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            title: recipe.title,
                            image: recipe.image,
                            time: recipe.time,
                            description: recipe.description,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe Image
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(recipe.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Recipe Details
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        recipe.time,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            selectedColor: Theme.of(context).primaryColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            selectedColor: Theme.of(context).primaryColor,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            selectedColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, BuildContext context) {
    String difficultyLevel = recipe.lessons.contains('2')
        ? 'Easy'
        : recipe.lessons.contains('3')
            ? 'Medium'
            : 'Hard';

    Color difficultyColor = difficultyLevel == 'Easy'
        ? Colors.green
        : difficultyLevel == 'Medium'
            ? Colors.orange
            : Colors.red;

    return AnimationConfiguration.staggeredGrid(
      position: recipesList.indexOf(recipe),
      duration: const Duration(milliseconds: 500),
      columnCount: 2,
      child: SlideAnimation(
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    title: recipe.title,
                    image: recipe.image,
                    time: recipe.time,
                    description: recipe.description,
                  ),
                ),
              );
            },
            child: Container(
              height: 120,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left side - Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.network(
                        recipe.image,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Right side - Content
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    recipe.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      recipe.time,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: difficultyColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    difficultyLevel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Favorite Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => _toggleFavorite(recipe),
                              child: Icon(
                                recipe.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: recipe.isFavorite
                                    ? Colors.red
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
