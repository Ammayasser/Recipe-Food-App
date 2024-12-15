import 'package:flutter/material.dart';
import '../widgets/user_header.dart';
import '../screens/home_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> recipesList;

  const FavoritesScreen({
    Key? key,
    required this.recipesList,
  }) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _showInstructions = true;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  Future<void> _checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenInstructions = prefs.getBool('has_seen_swipe_instructions') ?? false;
    setState(() {
      _showInstructions = !hasSeenInstructions;
    });
  }

  Future<void> _markInstructionsAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_swipe_instructions', true);
    setState(() {
      _showInstructions = false;
    });
  }

  Widget _buildInstructionCard() {
    return AnimatedOpacity(
      opacity: _showInstructions ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: _showInstructions
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.swipe_left,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Swipe left on a recipe to remove it from favorites',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _markInstructionsAsSeen,
                        color: Colors.blue.shade700,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  void _removeFromFavorites(Recipe recipe, int index, List<Recipe> favoriteRecipes) async {
    setState(() {
      recipe.isFavorite = false;
    });
    await FavoritesService.toggleFavorite(recipe.title);

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Recipe removed from favorites'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              recipe.isFavorite = true;
            });
            await FavoritesService.toggleFavorite(recipe.title);
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, BuildContext context, List<Recipe> favoriteRecipes, int index) {
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

    return Dismissible(
      key: Key(recipe.title),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete_outline,
          color: Colors.red.shade700,
          size: 30,
        ),
      ),
      onDismissed: (direction) {
        _removeFromFavorites(recipe, index, favoriteRecipes);
      },
      child: Tooltip(
        message: 'Swipe left to remove from favorites',
        preferBelow: false,
        child: Container(
          height: 120,
          margin: const EdgeInsets.all(10),
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
              child: Row(
                children: [
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recipe.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                recipe.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: difficultyColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  difficultyLevel,
                                  style: TextStyle(
                                    color: difficultyColor,
                                    fontSize: 12,
                                  ),
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes =
        widget.recipesList.where((recipe) => recipe.isFavorite).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const UserHeader(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite Recipes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${favoriteRecipes.length} items',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          _buildInstructionCard(),
          const SizedBox(height: 8),
          if (favoriteRecipes.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite recipes yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding recipes to your favorites!',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeCard(favoriteRecipes[index], context, favoriteRecipes, index);
              },
            ),
        ],
      ),
    );
  }
}
