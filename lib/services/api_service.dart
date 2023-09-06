import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/utils/constants.dart';

class ApiService {
  static fetchMoviesByType(String type, int page) async {
    final Uri uri;

    if (type == 'now_playing') {
      uri = Uri.parse('${Constants.NOW_PLAYING_URL}&page=$page');
    } else if (type == 'top_rated') {
      uri = Uri.parse('${Constants.TOP_RATED}&page=$page');
    } else if (type == 'popular') {
      uri = Uri.parse('${Constants.POPULAR_URL}&page=$page');
    } else if (type == 'upcoming') {
      uri = Uri.parse('${Constants.UPCOMING}&page=$page');
    } else {
      uri = Uri.parse('${Constants.NOW_PLAYING_URL}&page=$page');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['results'];

      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static getIndv(String id) async {
    final response = await http.get(Uri.parse(Constants().indvMovie(id)));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      IndividualMovie movie = IndividualMovie.fromJson(jsonResponse);

      return movie;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static searchMovie(String query) async {
    final response =
        await http.get(Uri.parse('${Constants.SEARCH_URL}&query=$query'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final List<dynamic> jsonData = jsonResponse['results'];

      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();

      return movies;
    }
  }
}
