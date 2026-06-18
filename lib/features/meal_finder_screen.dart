import 'package:flutter/material.dart';

class MealFinderPlaceholder extends StatelessWidget {
  const MealFinderPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderLayout(
      title: 'This is "What\'s in my Fridge?" Meal Finder Screen',
      description: 'Feature 5 Scope:\n- Dynamic interactive multiple checkbox list selection module.\n- Fetches recipe collections from Cloud Firestore with structural filtering options.\n- Displays Shariah-compliant healthy food cooking instructions.',
      icon: Icons.restaurant_menu,
    );
  }
}
// Clean helper widget to standardize the appearance of placeholder content
Widget _buildPlaceholderLayout({
  required String title,
  required String description,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Card(
          color: Colors.amber.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 13, height: 1.5, color: Colors.amber.shade900),
            ),
          ),
        ),
      ],
    ),
  )
  );
}