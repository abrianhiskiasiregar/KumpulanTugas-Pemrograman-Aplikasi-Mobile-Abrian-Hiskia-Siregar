import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://api.sampleapis.com/movies/horror';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Movie.fromJson(item)).toList();
    }

    throw Exception('Gagal mengambil data movies (status ${response.statusCode})');
  }
}
