import 'package:flutter/material.dart';
import '../models/food_category.dart';

class CategoryCard extends StatelessWidget {
  final FoodCategory category;
  final Color backgroundColor;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Center(
              child: ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: ${category.imageUrl}');
                      print('Error details: $error');
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.restaurant,
                          size: 30,
                          color: Colors.grey[800],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
