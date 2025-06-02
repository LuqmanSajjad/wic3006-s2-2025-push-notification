import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';


class WeeklyWeatherReport extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyWeather;
  const WeeklyWeatherReport({super.key, required this.weeklyWeather});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weeklyWeather.length,
        itemBuilder: (context, index) {
          final dayData = weeklyWeather[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayData["day"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Icon(dayData["icon"], size: 32, color: Colors.orange),
                const SizedBox(height: 8),
                Text('${dayData["temp"]}°C'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DailyWeatherReport extends StatelessWidget {
  final String city;
  final Map<String, Map<String, dynamic>> dailyWeather; // e.g. {'morning': {'weather': 'Sunny', 'temp': 28, 'icon': Icons.wb_sunny}, ...}

  const DailyWeatherReport({
    super.key,
    required this.city,
    required this.dailyWeather,
  });

  @override
  Widget build(BuildContext context) {
    final periods = ['morning', 'noon', 'afternoon', 'evening', 'night'];

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            city,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: periods.length,
              itemBuilder: (context, index) {
                final period = periods[index];
                final data = dailyWeather[period]!;
                return ListTile(
                  leading: Icon(data['icon'], size: 32, color: Colors.orange),
                  title: Text(
                    period[0].toUpperCase() + period.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${data['weather']}, ${data['temp']}°C'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List<Map<String, dynamic>> weeklyWeather = [];
  Map<String, Map<String, dynamic>> dailyWeather = {};
  String city = "Kuala Lumpur";

  @override
  void initState() {
    super.initState();
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    // Fetch JSON from the web
    final response = await NetworkAssetBundle(Uri.parse('https://randomvpn.jumpingcrab.com/weather/kuala_lumpur.json')).load("");
    final jsonString = utf8.decode(response.buffer.asUint8List());
    final Map<String, dynamic> data = json.decode(jsonString);

    setState(() {
      city = data['city'] ?? "Kuala Lumpur";
      weeklyWeather = List<Map<String, dynamic>>.from(data['weeklyWeather']);
      // Convert icon string to IconData
      for (var day in weeklyWeather) {
        day['icon'] = _iconFromString(day['icon']);
      }
      dailyWeather = {};
      (data['dailyWeather'] as Map<String, dynamic>).forEach((key, value) {
        dailyWeather[key] = Map<String, dynamic>.from(value);
        dailyWeather[key]!['icon'] = _iconFromString(value['icon']);
      });
    });
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'cloud':
        return Icons.cloud;
      case 'wb_cloudy':
        return Icons.wb_cloudy;
      case 'grain':
        return Icons.grain;
      case 'nights_stay':
        return Icons.nights_stay;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weeklyWeather.isEmpty || dailyWeather.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        WeeklyWeatherReport(weeklyWeather: weeklyWeather),
        const Divider(),
        DailyWeatherReport(
          city: city,
          dailyWeather: dailyWeather,
        ),
      ],
    );
  }
}
