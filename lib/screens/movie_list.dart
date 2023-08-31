import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:movies/widgets/movie_details.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool _isLoading = true;
  String errMsg = '';

  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      List<Movie> fetchedMovies = [];

      if (widget.type == 'now_playing') {
        fetchedMovies = await ApiService.fetchMoviesByType('now_playing', page);
      } else if (widget.type == 'top_rated') {
        fetchedMovies = await ApiService.fetchMoviesByType('top_rated', page);
      } else if (widget.type == 'popular') {
        fetchedMovies = await ApiService.fetchMoviesByType('popular', page);
      } else if (widget.type == 'upcoming') {
        fetchedMovies = await ApiService.fetchMoviesByType('upcoming', page);
      } else {
        fetchedMovies = await ApiService.fetchMoviesByType('now_playing', page);
      }

      setState(() {
        movies = movies + fetchedMovies;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        errMsg = 'Failed to load movie!';
        _isLoading = false;
      });
    }
  }

  void _openDetails(int movId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MovieDetails(id: movId),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  _scrollController.position.extentAfter == 0) {
                setState(() {
                  page = page + 1;
                });
                _fetchMovies();
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                if (errMsg != '') {
                  return Center(child: Text(errMsg));
                }
                return MovieCard(
                  movie: movies[index],
                  onTapMovie: () {
                    _openDetails(movies[index].id);
                  },
                );
              },
            ),
          );

    if (errMsg.isNotEmpty) {
      content = Center(
        child: Text(
          errMsg,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('List of Movies'),
      ),
      body: content,
    );
  }
}
