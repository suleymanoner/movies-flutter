import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/constants.dart';

class ApiService {
  static fetchMovies(int page) async {
    final response = await http.get(Uri.parse(
      '${Constants.TOP_RATED}&page=$page',
    ));

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
}
