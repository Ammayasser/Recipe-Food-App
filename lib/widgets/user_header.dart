import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building UserHeader');
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        print(
            'UserHeader theme state: isDarkMode = ${themeProvider.isDarkMode}');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Chef',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What would you like to cook?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        print('Theme toggle pressed in UserHeader');
                        themeProvider.toggleTheme();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
