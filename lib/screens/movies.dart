import 'package:flutter/material.dart';
import 'package:movies/screens/movie_list.dart';
import 'package:movies/widgets/movie_carousel_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/providers/movies_provider.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  String _errMsg = '';
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

      ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies(1);

      ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies(1);

      ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies(1);

      ref.read(popularMoviesProvider.notifier).fetchPopularMovies(1);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errMsg = 'Failed to load movies!';
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
    final nowPlayingMoviess = ref.watch(nowPlayingMoviesProvider);
    final topRatedMoviess = ref.watch(topRatedMoviesProvider);
    final upcomingMoviess = ref.watch(upcomingMoviesProvider);
    final popularMoviess = ref.watch(popularMoviesProvider);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieCarouselItem(
          title: 'Now Playing',
          onTapTitle: () {
            _goMovieList('Now Playing Movies');
          },
          list: nowPlayingMoviess,
        ),
        MovieCarouselItem(
          title: 'Top Rated',
          onTapTitle: () {
            _goMovieList('Top Rated Movies');
          },
          list: topRatedMoviess,
        ),
        MovieCarouselItem(
          title: 'Upcoming',
          onTapTitle: () {
            _goMovieList('Upcoming Movies');
          },
          list: upcomingMoviess,
        ),
        MovieCarouselItem(
          title: 'Popular',
          onTapTitle: () {
            _goMovieList('Popular Movies');
          },
          list: popularMoviess,
        ),
      ],
    );

    if (_isLoading) {
      content = const CircularProgressIndicator();
    }

    if (_errMsg.isNotEmpty) {
      content = Center(
        child: Text(
          _errMsg,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
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
