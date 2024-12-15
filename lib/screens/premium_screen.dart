import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
        centerTitle: true,
      ),
      body: Consumer<PremiumProvider>(
        builder: (context, premiumProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildFeaturesList(premiumProvider),
                const SizedBox(height: 24),
                _buildSubscribeButton(context, premiumProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.star,
          size: 64,
          color: Colors.amber[600],
        ),
        const SizedBox(height: 16),
        const Text(
          'Upgrade to Premium',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Get access to exclusive features and content',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesList(PremiumProvider premiumProvider) {
    final features = [
      {
        'title': 'Advanced Meal Planning',
        'description': 'Plan your meals for weeks with smart suggestions',
        'icon': Icons.calendar_today,
        'isAvailable': premiumProvider.hasAdvancedMealPlanning,
      },
      {
        'title': 'Chef Consultations',
        'description': 'Get expert advice from professional chefs',
        'icon': Icons.person,
        'isAvailable': premiumProvider.hasChefConsultations,
      },
      {
        'title': 'Exclusive Recipes',
        'description': 'Access premium recipes from renowned chefs',
        'icon': Icons.restaurant_menu,
        'isAvailable': premiumProvider.hasExclusiveRecipes,
      },
      {
        'title': 'Ad-Free Experience',
        'description': 'Enjoy cooking without interruptions',
        'icon': Icons.block,
        'isAvailable': premiumProvider.isAdFree,
      },
      {
        'title': 'Priority Support',
        'description': 'Get faster responses to your queries',
        'icon': Icons.support_agent,
        'isAvailable': premiumProvider.hasPrioritySupport,
      },
    ];

    return Column(
      children: features.map((feature) => _buildFeatureItem(feature)).toList(),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: Colors.amber[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            feature['isAvailable'] as bool
                ? Icons.check_circle
                : Icons.lock_outline,
            color: feature['isAvailable'] as bool
                ? Colors.green
                : Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(
      BuildContext context, PremiumProvider premiumProvider) {
    return ElevatedButton(
      onPressed: () async {
        // TODO: Implement actual payment processing
        // For demo purposes, we'll just toggle premium status
        await premiumProvider.setPremiumStatus(!premiumProvider.isPremium);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                premiumProvider.isPremium
                    ? 'Welcome to Premium!'
                    : 'Premium status removed',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.amber[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        premiumProvider.isPremium ? 'Cancel Premium' : 'Upgrade to Premium',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
