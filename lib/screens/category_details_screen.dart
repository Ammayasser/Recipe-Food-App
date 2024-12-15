import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryItem category;
  final List<Recipe> recipes;

  const CategoryDetailsScreen({
    Key? key,
    required this.category,
    required this.recipes,
  }) : super(key: key);

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<String> selectedFilters = [];
  final List<String> filters = ['Quick & Easy', 'Popular', 'Trending', 'New'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.category.name,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.category.image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Animated pattern overlay
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value * 2 * math.pi,
                            child: CustomPaint(
                              painter: PatternPainter(
                                  Theme.of(context).scaffoldBackgroundColor),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Category Description
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    getCategoryDescription(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),

              // Filter chips
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: filters.map((filter) {
                      final isSelected = selectedFilters.contains(filter);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedFilters.add(filter);
                              } else {
                                selectedFilters.remove(filter);
                              }
                            });
                          },
                          selectedColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.2),
                          checkmarkColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Stats cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Total Recipes',
                        '${getCategoryRecipes().length}',
                        Icons.restaurant_menu,
                        Theme.of(context).scaffoldBackgroundColor,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        'Avg. Time',
                        getCategoryStats()['avgTime']!,
                        Icons.timer,
                        Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ],
                  ),
                ),
              ),

              // Recipe Count and Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getCategoryRecipes().length} ${widget.category.name} Recipes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore our ${widget.category.name.toLowerCase()} collection',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recipe Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverAnimatedGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  initialItemCount: getCategoryRecipes().length,
                  itemBuilder: (context, index, animation) {
                    final recipe = getCategoryRecipes()[index];
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: const Offset(0.5, 0),
                            end: Offset.zero,
                          ),
                        ),
                        child: _buildRecipeCard(recipe),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Filter recipes based on category type
  List<Recipe> getCategoryRecipes() {
    final categoryType = widget.category.name.toLowerCase();
    return widget.recipes.where((recipe) {
      final title = recipe.title.toLowerCase();
      final desc = recipe.description.toLowerCase();

      switch (categoryType) {
        case 'breakfast':
          return title.contains('pancake') ||
              desc.contains('breakfast') ||
              desc.contains('morning');
        case 'main course':
          return title.contains('steak') ||
              title.contains('chicken') ||
              title.contains('pasta') ||
              desc.contains('main');
        case 'desserts':
          return desc.contains('sweet') ||
              desc.contains('dessert') ||
              title.contains('cake');
        case 'drinks':
          return desc.contains('drink') ||
              desc.contains('beverage') ||
              title.contains('juice') ||
              title.contains('latte') ||
              title.contains('punch') ||
              title.contains('mocktail') ||
              title.contains('chocolate') ||
              desc.contains('cocktail') ||
              desc.contains('refreshing');
        case 'healthy':
          return desc.contains('healthy') ||
              desc.contains('vegetable') ||
              title.contains('salad');
        default:
          return true;
      }
    }).toList();
  }

  // Category-specific stats
  Map<String, String> getCategoryStats() {
    switch (widget.category.name) {
      case 'Breakfast':
        return {
          'avgTime': '20 min',
          'type': 'Quick & Easy',
          'bestFor': 'Morning',
        };
      case 'Main Course':
        return {
          'avgTime': '45 min',
          'type': 'Full Meal',
          'bestFor': 'Lunch/Dinner',
        };
      case 'Desserts':
        return {
          'avgTime': '30 min',
          'type': 'Sweet Treats',
          'bestFor': 'Any Time',
        };
      case 'Drinks':
        return {
          'avgTime': '10 min',
          'type': 'Beverages',
          'bestFor': 'Any Time',
        };
      case 'Healthy':
        return {
          'avgTime': '25 min',
          'type': 'Nutritious',
          'bestFor': 'Daily',
        };
      default:
        return {
          'avgTime': '30 min',
          'type': 'Various',
          'bestFor': 'Any Time',
        };
    }
  }

  // Category-specific description
  String getCategoryDescription() {
    switch (widget.category.name) {
      case 'Breakfast':
        return 'Start your day with our energizing breakfast recipes. Perfect for busy mornings!';
      case 'Main Course':
        return 'Discover hearty and satisfying main dishes that will be the star of your meal.';
      case 'Desserts':
        return 'Indulge in our delightful collection of sweet treats and desserts.';
      case 'Drinks':
        return 'Refresh yourself with our selection of beverages and drinks.';
      case 'Healthy':
        return 'Nourish your body with our healthy and nutritious recipe collection.';
      default:
        return 'Explore our delicious recipes collection.';
    }
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Recipe Image
            Positioned.fill(
              child: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Recipe Info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: Theme.of(context).iconTheme.color,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.time,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final spacing = size.width / 10;
    for (var i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        spacing * i,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
