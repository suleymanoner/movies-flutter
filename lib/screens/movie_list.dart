import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/providers/movies_provider.dart';
import 'package:movies/providers/tv_shows_provider.dart';
import 'package:movies/screens/show_details.dart';
import 'package:movies/widgets/movie/movie_card.dart';
import 'package:movies/widgets/movie/movie_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/widgets/show/show_card.dart';

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
    _fetchMoviesOrShows();
  }

  Future<void> _fetchMoviesOrShows() async {
    try {
      if (widget.type == 'Now Playing Movies') {
        ref.read(nowPlayingMoviesProvider.notifier).fetchNowPlayingMovies(page);
      } else if (widget.type == 'Top Rated Movies') {
        ref.read(topRatedMoviesProvider.notifier).fetchTopRatedMovies(page);
      } else if (widget.type == 'Popular Movies') {
        ref.read(popularMoviesProvider.notifier).fetchPopularMovies(page);
      } else if (widget.type == 'Upcmoming Movies') {
        ref.read(upcomingMoviesProvider.notifier).fetchUpcomingMovies(page);
      } else if (widget.type == 'On The Air Shows') {
        ref.read(onTheAirProvider.notifier).fetchOnTheAirShows(page);
      } else if (widget.type == 'Top Rated Shows') {
        ref.read(topRatedShowsProvider.notifier).fetchTopRatedShows(page);
      } else if (widget.type == 'Airing Today Shows') {
        ref.read(airingTodayShowsProvider.notifier).fetchUAiringShows(page);
      } else if (widget.type == 'Popular Shows') {
        ref.read(popularShowsProvider.notifier).fetchPopularShows(page);
      } else {
        ref.read(popularShowsProvider.notifier).fetchPopularShows(page);
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

  void _openDetails(int id) {
    if (widget.type.contains('Shows')) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ShowDetailsScreen(id: id);
        },
      ));
    } else {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => MovieDetails(id: id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> moviesOrShows = [];
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);

    final onTheAirShows = ref.watch(onTheAirProvider);
    final airingTodayShows = ref.watch(airingTodayShowsProvider);
    final topRatedShows = ref.watch(topRatedShowsProvider);
    final popularShows = ref.watch(popularShowsProvider);

    if (widget.type == 'Now Playing Movies') {
      moviesOrShows = nowPlayingMovies;
    } else if (widget.type == 'Top Rated Movies') {
      moviesOrShows = topRatedMovies;
    } else if (widget.type == 'Popular Movies') {
      moviesOrShows = popularMovies;
    } else if (widget.type == 'Upcoming Movies') {
      moviesOrShows = upcomingMovies;
    } else if (widget.type == 'On The Air Shows') {
      moviesOrShows = onTheAirShows;
    } else if (widget.type == 'Top Rated Shows') {
      moviesOrShows = topRatedShows;
    } else if (widget.type == 'Airing Today Shows') {
      moviesOrShows = airingTodayShows;
    } else if (widget.type == 'Popular Shows') {
      moviesOrShows = popularShows;
    } else {
      moviesOrShows = topRatedShows;
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
                _fetchMoviesOrShows();
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: moviesOrShows.length,
              itemBuilder: (ctx, index) {
                if (errMsg != '') {
                  return Center(child: Text(errMsg));
                }

                if (widget.type.contains('Shows')) {
                  return ShowCard(
                      show: moviesOrShows[index],
                      onTapShow: () {
                        _openDetails(moviesOrShows[index].id);
                      });
                }
                return MovieCard(
                  movie: moviesOrShows[index],
                  onTapMovie: () {
                    _openDetails(moviesOrShows[index].id);
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
        title: Text(widget.type),
      ),
      body: content,
    );
  }
}
