// lib/services/weather_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

enum WeatherErrorType { network, timeout, unauthorized, unknown }

class WeatherServiceException implements Exception {
  final WeatherErrorType type;
  final String message;
  WeatherServiceException(this.type, this.message);

  @override
  String toString() => message;
}

class WeatherService {
  late StreamController<WeatherModel> _controller;
  Timer? _updateTimer;

  // API Key kamu sudah dimasukkan
  final String apiKey = '8117282b800150237c9c345c2d0abb99';
  final List<String> cities = ['Medan', 'Jakarta', 'Bandung', 'Surabaya'];
  int _currentCityIndex = 0;

  WeatherService() {
    _initController();
  }

  void _initController() {
    // Menggunakan broadcast agar bisa di-listen kapan saja
    _controller = StreamController<WeatherModel>.broadcast();
    _startUpdates();
  }

  void _startUpdates() {
    _updateTimer?.cancel();

    // Beri sedikit jeda agar UI StreamBuilder siap mendengarkan data
    Future.delayed(const Duration(milliseconds: 500), () {
      _fetchRealWeather();
    });

    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_controller.isClosed) {
        _fetchRealWeather();
      }
    });
  }

  Future<void> _fetchRealWeather() async {
    final city = cities[_currentCityIndex];
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    try {
      print("-> Mengambil data cuaca untuk: $city");
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      print("-> Status Code API: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _controller.add(WeatherModel.fromJson(data));
        _currentCityIndex = (_currentCityIndex + 1) % cities.length;
      } else if (response.statusCode == 401) {
        _controller.addError(
          WeatherServiceException(
            WeatherErrorType.unauthorized,
            'API Key kamu belum aktif. Tunggu sekitar 1-2 jam dari OpenWeatherMap.',
          ),
        );
      } else {
        _controller.addError(
          WeatherServiceException(
            WeatherErrorType.network,
            'Gagal mengambil data (Error ${response.statusCode})',
          ),
        );
      }
    } on TimeoutException {
      _controller.addError(
        WeatherServiceException(
          WeatherErrorType.timeout,
          'Koneksi internet lambat / server tidak merespon.',
        ),
      );
    } catch (e) {
      _controller.addError(
        WeatherServiceException(
          WeatherErrorType.unknown,
          'Cek koneksi internetmu! (Detail: $e)',
        ),
      );
    }
  }

  void retry() {
    if (!_controller.isClosed) {
      _controller.close();
    }
    _currentCityIndex = 0; // Mulai lagi dari Medan
    _initController();
  }

  Stream<WeatherModel> get stream => _controller.stream;

  void dispose() {
    _updateTimer?.cancel();
    _controller.close();
  }
}
