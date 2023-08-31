import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:movies/widgets/movie_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  String errMsg = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final fetchedMovies = await ApiService.fetchMovies(page);

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

  void _openDetails(Movie movie) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MovieDetails(id: movie.id),
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
                    _openDetails(movies[index]);
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
      body: content,
    );
  }
}
