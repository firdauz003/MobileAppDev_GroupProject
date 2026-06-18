import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class HydrationScreen extends ConsumerWidget {
  const HydrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(hydrationProvider);
    const dailyGoal = 8;
    final progressValue = (count / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_drink, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            Text(
              'Hydration Tracker',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'You drank $count glasses today',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progressValue,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(hydrationProvider.notifier).state++;
                    _saveHydrationLog(ref.read(hydrationProvider));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Glass'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (count > 0) {
                      ref.read(hydrationProvider.notifier).state--;
                      _saveHydrationLog(ref.read(hydrationProvider));
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove Glass'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHydrationLog(int count) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month}-${today.day}';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('hydration_log')
          .doc(dateKey)
          .set({
        'glasses': count,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
