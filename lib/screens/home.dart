import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final fetchedMovies = await ApiService.fetchMovies();

      setState(() {
        movies = fetchedMovies;
      });
    } catch (error) {
      // Handle error
      print('Error fetching movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (ctx, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}
