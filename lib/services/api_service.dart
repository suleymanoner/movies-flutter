import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/utils/constants.dart';

class ApiService {
  static fetchMoviesByType(String type, int page) async {
    final Uri uri;

    if (type == 'now_playing') {
      uri = Uri.parse('${Constants.NOW_PLAYING_URL}&page=$page');
    } else if (type == 'top_rated') {
      uri = Uri.parse('${Constants.TOP_RATED_MOV}&page=$page');
    } else if (type == 'popular') {
      uri = Uri.parse('${Constants.POPULAR_MOV_URL}&page=$page');
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

  static getIndvMovie(String id) async {
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
        await http.get(Uri.parse('${Constants.SEARCH_MOV_URL}&query=$query'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final List<dynamic> jsonData = jsonResponse['results'];

      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();

      return movies;
    }
  }

  static fetchTvShowsByType(String type, int page) async {
    final Uri uri;

    if (type == 'on_the_air') {
      uri = Uri.parse('${Constants.ON_THE_AIR}&page=$page');
    } else if (type == 'top_rated') {
      uri = Uri.parse('${Constants.TOP_RATED_TV}&page=$page');
    } else if (type == 'popular') {
      uri = Uri.parse('${Constants.POPULAR_TV_URL}&page=$page');
    } else if (type == 'airing_today') {
      uri = Uri.parse('${Constants.AIRING_TODAY}&page=$page');
    } else {
      uri = Uri.parse('${Constants.ON_THE_AIR}&page=$page');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> jsonData = jsonResponse['results'];

      final shows = jsonData.map((e) => TvShow.fromJson(e)).toList();

      return shows;
    } else {
      throw Exception('Failed to load tv shows');
    }
  }

  static fetchIndvTvShow(String id) async {
    final response = await http.get(Uri.parse(Constants().indvShow(id)));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      IndividualTvShow show = IndividualTvShow.fromJson(jsonResponse);

      return show;
    } else {
      throw Exception('Failed to load tv show');
    }
  }

  static searchShow(String query) async {
    final response =
        await http.get(Uri.parse('${Constants.SEARCH_TV_URL}&query=$query'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final List<dynamic> jsonData = jsonResponse['results'];

      final shows = jsonData.map((e) => TvShow.fromJson(e)).toList();

      return shows;
    }
  }
}
