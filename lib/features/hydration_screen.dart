import 'package:flutter/material.dart';

class HydrationTrackerPlaceholder extends StatelessWidget {
  const HydrationTrackerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderLayout(
      title: 'This is Hydration Tracker Screen',
      description: 'Feature 4 Scope:\n- Interactive custom state management engine (Provider/Riverpod).\n- Dynamic increment/decrement counters mimicking water cups log tracking.\n- Reactive tracking progress bar component tracking completion.',
      icon: Icons.local_drink,
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