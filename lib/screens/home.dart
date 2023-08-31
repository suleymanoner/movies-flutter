import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/movie_list.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:movies/widgets/movie_carousel_item.dart';
import 'package:movies/widgets/movie_details.dart';
import 'package:movies/widgets/carousel_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> nowPlayingMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> upcomingMovies = [];

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

      final fetchedNowPlayingMovies =
          await ApiService.fetchMoviesByType('now_playing', 1);

      final fetchedTopRatedMovies =
          await ApiService.fetchMoviesByType('top_rated', 1);

      final fetchedPopularMovies =
          await ApiService.fetchMoviesByType('popular', 1);

      final fetchedUpcomingMovies =
          await ApiService.fetchMoviesByType('upcoming', 1);

      setState(() {
        nowPlayingMovies = nowPlayingMovies + fetchedNowPlayingMovies;
        topRatedMovies = topRatedMovies + fetchedTopRatedMovies;
        popularMovies = popularMovies + fetchedPopularMovies;
        upcomingMovies = upcomingMovies + fetchedUpcomingMovies;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        errMsg = 'Failed to load movie!';
        _isLoading = false;
      });
    }
  }

  void _goMovieList(String type) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MovieListScreen(type: type),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieCarouselItem(
          title: 'Now Playing Movies',
          onTapTitle: () {
            _goMovieList('now_playing');
          },
          movieList: nowPlayingMovies,
        ),
        MovieCarouselItem(
          title: 'Top Rated Movies',
          onTapTitle: () {
            _goMovieList('top_rated');
          },
          movieList: topRatedMovies,
        ),
        MovieCarouselItem(
          title: 'Upcoming Movies',
          onTapTitle: () {
            _goMovieList('upcoming');
          },
          movieList: upcomingMovies,
        ),
        MovieCarouselItem(
          title: 'Popular Movies',
          onTapTitle: () {
            _goMovieList('popular');
          },
          movieList: popularMovies,
        ),
      ],
    );

    if (_isLoading) {
      content = const CircularProgressIndicator();
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: content,
        ),
      ),
    );
  }
}
