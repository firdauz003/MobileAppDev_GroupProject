import 'package:flutter/material.dart';
import 'features/auth_profile_screen.dart';
import 'features/prayer_qibla_screen.dart';
import 'features/dashboard_screen.dart';
import 'features/hydration_screen.dart';
import 'features/meal_finder_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MizanApp());
}

class MizanApp extends StatelessWidget {
  const MizanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mizan: Your Daily Deen & Health Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
      ),
      home: const UniversalNavigationHub(),
    );
  }
}

class UniversalNavigationHub extends StatefulWidget {
  const UniversalNavigationHub({Key? key}) : super(key: key);

  @override
  State<UniversalNavigationHub> createState() => _UniversalNavigationHubState();
}

class _UniversalNavigationHubState extends State<UniversalNavigationHub> {
  // Keeps track of the currently selected tab
  int _currentIndex = 0;

  // 1. Array containing your working features + clear placeholder layouts for team members
  final List<Widget> _screens = [
    const AuthProfileScreen(), // Feature 1 (Your Task)
    const MainDashboardPlaceholder(), // Feature 2 (Team Task)
    const PrayerQiblaScreen(), // Feature 3 (Your Task)
    const HydrationTrackerPlaceholder(), // Feature 4 (Team Task)
    const MealFinderPlaceholder(), // Feature 5 (Team Task)
  ];

  // 2. Titles displayed dynamically on the central AppBar wrapper
  final List<String> _titles = [
    'Profile Setup (Feature 1)',
    'Daily Deen Dashboard (Feature 2)',
    'Prayer & Qibla (Feature 3)',
    'Hydration Tracker (Feature 4)',
    'Meal Finder (Feature 5)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 2,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // 3. Universal Bottom Navigation Component Matrix
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Preserves layout constraints for 4+ items
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile/Auth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Deen Dash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Prayer/Qibla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Hydration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Finder',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PLACEHOLDER SCREENS FOR YOUR TEAM MODULES
// ==========================================


// // Clean helper widget to standardize the appearance of placeholder content
// Widget _buildPlaceholderLayout({
//   required String title,
//   required String description,
//   required IconData icon,
// }) {
//   return Center(
//     padding: const EdgeInsets.all(32.0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: 70, color: Colors.grey.shade400),
//         const SizedBox(height: 16),
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.slate),
//         ),
//         const SizedBox(height: 12),
//         Card(
//           color: Colors.amber.shade50,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               description,
//               style: TextStyle(fontSize: 13, height: 1.5, color: Colors.amber.shade900),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }