import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/premium_provider.dart';
import '../screens/premium_screen.dart';
import '../widgets/user_header.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, PremiumProvider>(
      builder: (context, themeProvider, premiumProvider, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: themeProvider.toggleTheme,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const UserHeader(),
                  const SizedBox(height: 24),
                  _buildPremiumCard(context, premiumProvider),
                  const SizedBox(height: 24),
                  _buildProfileSection(context),
                  const SizedBox(height: 32),
                  _buildSettingsSection(context, themeProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard(
      BuildContext context, PremiumProvider premiumProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[400]!, Colors.amber[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  premiumProvider.isPremium ? Icons.star : Icons.star_border,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    premiumProvider.isPremium
                        ? 'Premium Member'
                        : 'Upgrade to Premium',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              premiumProvider.isPremium
                  ? 'Enjoy all premium features'
                  : 'Get access to exclusive features and content',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.amber[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  premiumProvider.isPremium
                      ? 'Manage Subscription'
                      : 'Learn More',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chef Profile',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Account Settings'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context: context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Implement edit profile
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.email_outlined,
            title: 'Email Preferences',
            onTap: () {
              // TODO: Implement email preferences
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'App Settings'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context: context,
            icon: themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            title: 'Theme',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: const Switch(
              value: true,
              onChanged: null,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'About'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context: context,
            icon: Icons.info_outline,
            title: 'App Version',
            trailing: const Text('1.0.0'),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Implement privacy policy
            },
          ),
        ],
      ),
    );
  }
}
