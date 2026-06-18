import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(authProfileProvider);
    final hydrationCount = ref.watch(hydrationProvider);
    final dailyQuote = ref.watch(dailyQuoteProvider);
    final prayerTimes = ref.watch(todayPrayerTimesProvider);
    final nextPrayer = ref.watch(nextPrayerProvider);
    final prayerCountdown = ref.watch(prayerCountdownProvider);

    final today = DateTime.now();
    final hijriDate = '${today.day} ${_monthName(today.month)} ${today.year} AH';
    final dailyWaterGoal = userProfile?.waterGoal ?? 2.5;
    final hydrationProgress = (hydrationCount / (dailyWaterGoal * 4)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildHeader(context, userProfile),
            const SizedBox(height: 20),
            _buildStatusCards(context, hydrationCount, dailyWaterGoal, hydrationProgress, nextPrayer, prayerCountdown),
            const SizedBox(height: 20),
            _buildPrayerSection(prayerTimes),
            const SizedBox(height: 20),
            _buildQuoteCard(dailyQuote),
            const SizedBox(height: 20),
            _buildCalendarMatrix(hijriDate),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile? profile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.teal,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.dashboard, color: Colors.white, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Deen Dashboard',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile != null ? 'Hello, ${profile.email}' : 'Welcome to Mizan',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile != null ? 'User category: ${profile.userCategory}' : 'Please login to unlock full stats',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(BuildContext context, int hydrationCount, double waterGoal, double progress, String nextPrayer, String prayerCountdown) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMiniCard(
              title: 'Hydration',
              value: '$hydrationCount glasses',
              subtitle: 'Goal ${waterGoal.toStringAsFixed(1)}L',
              icon: Icons.local_drink,
              color: Colors.teal,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildMiniCard(
              title: 'Next Prayer',
              value: nextPrayer,
              subtitle: prayerCountdown,
              icon: Icons.access_time,
              color: Colors.orange,
            )),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hydration Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: progress, minHeight: 10, color: Colors.teal, backgroundColor: Colors.teal.shade100),
                const SizedBox(height: 8),
                Text('${(progress * 100).round()}% of daily water target', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({required String title, required String value, required String subtitle, required IconData icon, required Color color}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 14),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerSection(Map<String, String> prayerTimes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prayer Times', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...prayerTimes.entries.map((entry) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 1,
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.schedule, color: Colors.teal),
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildQuoteCard(String quote) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.amber.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Inspiration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('"$quote"', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarMatrix(String hijriDate) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final matrix = List.generate(7, (row) => List.generate(4, (col) => '${row * 4 + col + 1}'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hijri Date Matrix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(hijriDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days.map((day) => Expanded(child: Text(day, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)))).toList(),
                ),
                const SizedBox(height: 10),
                ...matrix.map((row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: row.map((value) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                      ),
                    )).toList(),
                  ),
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha’ban',
      'Ramadan', 'Shawwal', 'Dhu al-Qi’dah', 'Dhu al-Hijjah',
    ];
    return names[(month - 1).clamp(0, names.length - 1)];
  }
}
