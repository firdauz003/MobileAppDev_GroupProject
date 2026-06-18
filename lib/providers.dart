import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class UserProfile {
  final String email;
  final String userCategory;
  final double waterGoal;

  const UserProfile({
    required this.email,
    required this.userCategory,
    required this.waterGoal,
  });

  UserProfile copyWith({
    String? email,
    String? userCategory,
    double? waterGoal,
  }) {
    return UserProfile(
      email: email ?? this.email,
      userCategory: userCategory ?? this.userCategory,
      waterGoal: waterGoal ?? this.waterGoal,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  Future<void> login(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = UserProfile(
      email: email,
      userCategory: 'Student',
      waterGoal: 2.5,
    );
  }

  Future<void> register({
    required String email,
    required String userCategory,
    required double waterGoal,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = UserProfile(
      email: email,
      userCategory: userCategory,
      waterGoal: waterGoal,
    );
  }

  Future<void> updateProfile({
    required String userCategory,
    required double waterGoal,
  }) async {
    if (state == null) return;
    await Future.delayed(const Duration(milliseconds: 300));
    state = state!.copyWith(
      userCategory: userCategory,
      waterGoal: waterGoal,
    );
  }

  void logout() {
    state = null;
  }
}

final authProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

final hydrationProvider = StateProvider<int>((ref) => 0);

final dailyQuoteProvider = Provider<String>((ref) {
  final quotes = [
    'Seek knowledge from the cradle to the grave.',
    'A strong believer is better and more beloved to Allah than a weak believer.',
    'The best of you are those who learn the Qur’an and teach it.',
    'Prayer is the key to success; guard it as you guard your soul.',
  ];
  final index = DateTime.now().day % quotes.length;
  return quotes[index];
});

final todayPrayerTimesProvider = Provider<Map<String, String>>((ref) {
  final coordinates = Coordinates(3.1390, 101.6869);
  final params = CalculationMethod.singapore.getParameters();
  params.madhab = Madhab.shafi;
  final prayerTimes = PrayerTimes.today(coordinates, params);
  final formatter = DateFormat('hh:mm a');

  return {
    'Fajr': formatter.format(prayerTimes.fajr.toLocal()),
    'Sunrise': formatter.format(prayerTimes.sunrise.toLocal()),
    'Dhuhr': formatter.format(prayerTimes.dhuhr.toLocal()),
    'Asr': formatter.format(prayerTimes.asr.toLocal()),
    'Maghrib': formatter.format(prayerTimes.maghrib.toLocal()),
    'Isha': formatter.format(prayerTimes.isha.toLocal()),
  };
});

final todayPrayerDateTimeProvider = Provider<Map<String, DateTime>>((ref) {
  final coordinates = Coordinates(3.1390, 101.6869);
  final params = CalculationMethod.singapore.getParameters();
  params.madhab = Madhab.shafi;
  final prayerTimes = PrayerTimes.today(coordinates, params);

  return {
    'Fajr': prayerTimes.fajr.toLocal(),
    'Sunrise': prayerTimes.sunrise.toLocal(),
    'Dhuhr': prayerTimes.dhuhr.toLocal(),
    'Asr': prayerTimes.asr.toLocal(),
    'Maghrib': prayerTimes.maghrib.toLocal(),
    'Isha': prayerTimes.isha.toLocal(),
  };
});

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

final nextPrayerEntryProvider = Provider<MapEntry<String, DateTime>>((ref) {
  final now = DateTime.now();
  final prayerTimes = ref.watch(todayPrayerDateTimeProvider);

  final upcoming = prayerTimes.entries.where((entry) => entry.value.isAfter(now)).toList();
  if (upcoming.isNotEmpty) {
    return upcoming.first;
  }

  final coordinates = Coordinates(3.1390, 101.6869);
  final params = CalculationMethod.singapore.getParameters();
  params.madhab = Madhab.shafi;
  final tomorrowDate = DateTime.now().add(const Duration(days: 1));
  final tomorrow = PrayerTimes(coordinates, DateComponents.from(tomorrowDate), params);

  return MapEntry('Fajr', tomorrow.fajr.toLocal());
});

final nextPrayerProvider = Provider<String>((ref) {
  final nextPrayer = ref.watch(nextPrayerEntryProvider);
  final formatter = DateFormat('hh:mm a');
  return '${nextPrayer.key} at ${formatter.format(nextPrayer.value)}';
});

final prayerCountdownProvider = Provider<String>((ref) {
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  final nextPrayer = ref.watch(nextPrayerEntryProvider);
  final duration = nextPrayer.value.difference(now);
  final safeDuration = duration.isNegative ? Duration.zero : duration;

  final hours = safeDuration.inHours.toString().padLeft(2, '0');
  final minutes = (safeDuration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (safeDuration.inSeconds % 60).toString().padLeft(2, '0');

  return '${nextPrayer.key} in $hours:$minutes:$seconds';
});
