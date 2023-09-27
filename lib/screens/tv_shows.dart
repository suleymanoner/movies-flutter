import 'package:flutter/material.dart';
import 'package:movies/providers/tv_shows_provider.dart';
import 'package:movies/screens/movie_list.dart';
import 'package:movies/widgets/movie_carousel_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvShowsScreen extends ConsumerStatefulWidget {
  const TvShowsScreen({super.key});

  @override
  ConsumerState<TvShowsScreen> createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends ConsumerState<TvShowsScreen> {
  String _errMsg = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  Future<void> _fetchTvShows() async {
    try {
      setState(() {
        _isLoading = true;
      });

      ref.read(onTheAirProvider.notifier).fetchOnTheAirShows(1);

      ref.read(airingTodayShowsProvider.notifier).fetchUAiringShows(1);

      ref.read(topRatedShowsProvider.notifier).fetchTopRatedShows(1);

      ref.read(popularShowsProvider.notifier).fetchPopularShows(1);

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errMsg = 'Failed to load shows!';
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
    final onTheAirShows = ref.watch(onTheAirProvider);
    final airingTodayShows = ref.watch(airingTodayShowsProvider);
    final topRatedShows = ref.watch(topRatedShowsProvider);
    final popularShows = ref.watch(popularShowsProvider);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieCarouselItem(
          title: 'On The Air',
          onTapTitle: () {
            _goMovieList('On The Air Shows');
          },
          list: onTheAirShows,
          isMovie: false,
        ),
        MovieCarouselItem(
          title: 'Top Rated',
          onTapTitle: () {
            _goMovieList('Top Rated Shows');
          },
          list: topRatedShows,
          isMovie: false,
        ),
        MovieCarouselItem(
          title: 'Airing Today',
          onTapTitle: () {
            _goMovieList('Airing Today Shows');
          },
          list: airingTodayShows,
          isMovie: false,
        ),
        MovieCarouselItem(
          title: 'Popular',
          onTapTitle: () {
            _goMovieList('Popular Shows');
          },
          list: popularShows,
          isMovie: false,
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
