import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class PrayerQiblaScreen extends StatefulWidget {
  const PrayerQiblaScreen({Key? key}) : super(key: key);

  @override
  State<PrayerQiblaScreen> createState() => _PrayerQiblaScreenState();
}

class _PrayerQiblaScreenState extends State<PrayerQiblaScreen> {
  // Static context setup targeting local capital coordinates (Kuala Lumpur)
  final double latitude = 3.1390;
  final double longitude = 101.6869;
  
  late PrayerTimes _prayerTimes;
  double? _compassHeading = 0;
  double _qiblaDirection = 0;

  @override
  void initState() {
    super.initState();
    _calculatePrayerTimes();
    _calculateQiblaBearing();
    _initCompassStream();
  }

  void _calculatePrayerTimes() {
    final coordinates = Coordinates(latitude, longitude);
    // Fixed: pass the enum value directly without the trailing parentheses
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    
    _prayerTimes = PrayerTimes.today(coordinates, params);
  }

  void _calculateQiblaBearing() {
    final coordinates = Coordinates(latitude, longitude);
    // Fixed: Qibla calculation using the proper object constructor syntax
    _qiblaDirection = Qibla(coordinates).direction;
  }

  void _initCompassStream() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _compassHeading = event.heading;
        });
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    double compassNeedleDirection = 0;
    if (_compassHeading != null) {
      compassNeedleDirection = (_qiblaDirection - _compassHeading!) * (math.pi / 180 * -1);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),
          _buildCompassCard(compassNeedleDirection),
          const SizedBox(height: 20),
          const Text(
            'Today\'s Prayer Times (Kuala Lumpur)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 10),
          _buildPrayerRow('Fajr', _formatTime(_prayerTimes.fajr)),
          _buildPrayerRow('Sunrise', _formatTime(_prayerTimes.sunrise)),
          _buildPrayerRow('Dhuhr', _formatTime(_prayerTimes.dhuhr)),
          _buildPrayerRow('Asr', _formatTime(_prayerTimes.asr)),
          _buildPrayerRow('Maghrib', _formatTime(_prayerTimes.maghrib)),
          _buildPrayerRow('Isha', _formatTime(_prayerTimes.isha)),
        ],
      ),
    );
  }

  Widget _buildCompassCard(double needleAngle) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // Fixed: Swapped invalid parameter 'children' out for 'child: Row(...)'
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.explore, color: Colors.teal),
                SizedBox(width: 8),
                Text('Qibla Compass Indicator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.teal.shade200, width: 4),
                      ),
                    ),
                    Transform.rotate(
                      angle: needleAngle,
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/148/148838.png', 
                        height: 120,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.navigation,
                          size: 80,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Bearing: ${_qiblaDirection.toStringAsFixed(1)}° N',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
          ],
        ),
      ),
    );
  }
}