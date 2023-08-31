import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/constants.dart';

class ApiService {
  static fetchMovies() async {
    final response = await http.get(Uri.parse(Constants.NOW_PLAYING_URL));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['results'];

      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
