// lib/main.dart
import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';
import 'widgets/weather_display.dart';
import 'widgets/weather_skeleton.dart';
import 'widgets/error_display.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherService _weatherService;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService();
  }

  void _handleRetry() {
    // Kita panggil ulang service dari awal
    setState(() {
      _weatherService.retry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Aplikasi Cuaca Real-time'),
        backgroundColor: Colors.blue[50],
      ),
      body: StreamBuilder<WeatherModel>(
        stream: _weatherService.stream,
        builder: (context, snapshot) {
          // 1. Cek Error
          if (snapshot.hasError) {
            return ErrorDisplay(error: snapshot.error!, onRetry: _handleRetry);
          }

          // 2. Cek Loading Pertama (Waiting)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WeatherSkeleton();
          }

          // 3. Tampilkan Data (Success)
          if (snapshot.hasData) {
            return WeatherDisplay(weather: snapshot.data!);
          }

          // 4. Fallback (Jika tidak ada data sama sekali)
          return const Center(child: Text('Menunggu data cuaca...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleRetry,
        tooltip: 'Refresh Manual',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }
}
