import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/providers/movies_provider.dart';
import 'package:movies/widgets/movie_card.dart';
import 'package:movies/widgets/movie_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({
    super.key,
    required this.type,
  });

  final String type;

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool _isLoading = true;
  String errMsg = '';

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      if (widget.type == 'Now Playing') {
        ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies(page);
      } else if (widget.type == 'Top Rated') {
        ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies(page);
      } else if (widget.type == 'Popular') {
        ref.read(popularMoviesProvider.notifier).fetchPopularMovies(page);
      } else if (widget.type == 'Upcmoming') {
        ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies(page);
      } else {
        ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies(page);
      }

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
    List<Movie> movies = [];
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);

    if (widget.type == 'Now Playing') {
      movies = nowPlayingMovies;
    } else if (widget.type == 'Top Rated') {
      movies = topRatedMovies;
    } else if (widget.type == 'Popular') {
      movies = popularMovies;
    } else if (widget.type == 'Upcoming') {
      movies = upcomingMovies;
    } else {
      movies = nowPlayingMovies;
    }

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
        title: Text('${widget.type} Movies'),
      ),
      body: content,
    );
  }
}
