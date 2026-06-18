import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth_profile_screen.dart';
import 'features/prayer_qibla_screen.dart';
import 'features/hydration_screen.dart';
//import 'features/dashboard_screen.dart';
import 'features/meal_finder_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MizanApp()));
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
    const HydrationScreen(), // Feature 4 (Team Task)
    const MealFinderScreen(), // Feature 5 (Team Task)
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

class MainDashboardPlaceholder extends StatelessWidget {
  const MainDashboardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Daily Deen Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Feature 2 - Coming Soon'),
            ),
          ),
        ],
      ),
    );
  }
}

class HydrationTrackerPlaceholder extends StatelessWidget {
  const HydrationTrackerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_drink, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Hydration Tracker',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.cyan.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Feature 4 - Coming Soon'),
            ),
          ),
        ],
      ),
    );
  }
}

class MealFinderPlaceholder extends StatelessWidget {
  const MealFinderPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Meal Finder',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Feature 5 - Coming Soon'),
            ),
          ),
        ],
      ),
    );
  }
}
