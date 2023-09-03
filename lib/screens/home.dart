import 'package:flutter/material.dart';
import 'package:movies/screens/movie_list.dart';
import 'package:movies/widgets/movie_carousel_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/providers/movies_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

      ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies(1);

      ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies(1);

      ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies(1);

      ref.read(popularMoviesProvider.notifier).fetchPopularMovies(1);

      setState(() {
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
            _goMovieList('Now Playing');
          },
          movieList: nowPlayingMoviess,
        ),
        MovieCarouselItem(
          title: 'Top Rated',
          onTapTitle: () {
            _goMovieList('Top Rated');
          },
          movieList: topRatedMoviess,
        ),
        MovieCarouselItem(
          title: 'Upcoming',
          onTapTitle: () {
            _goMovieList('Upcoming');
          },
          movieList: upcomingMoviess,
        ),
        MovieCarouselItem(
          title: 'Popular',
          onTapTitle: () {
            _goMovieList('Popular');
          },
          movieList: popularMoviess,
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
