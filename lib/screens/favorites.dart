import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/providers/favorites_provider.dart';
import 'package:movies/screens/show_details.dart';
import 'package:movies/widgets/favorite_item.dart';
import 'package:movies/widgets/movie/movie_details.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FavoriteScreenState();
  }
}

class _FavoriteScreenState extends ConsumerState<FavoritesScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoritesIfEmpty();
  }

  Future<void> _loadFavoritesIfEmpty() async {
    final favMovies = ref.read(favoriteMoviesProvider);
    final favShows = ref.read(favoriteShowsProvider);

    if (favMovies.isEmpty && favShows.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      await ref.read(favoriteMoviesProvider.notifier).fetchFromFirebase();
      await ref.read(favoriteShowsProvider.notifier).fetchFromFirebase();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favMovies = ref.watch(favoriteMoviesProvider);
    final favShows = ref.watch(favoriteShowsProvider);

    void openMovieDetails(int movId) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => MovieDetails(id: movId),
      );
    }

    void openShowDetails(int id) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return ShowDetailsScreen(id: id);
        },
      ));
    }

    List<Widget> favoritesList = [];

    for (var movie in favMovies) {
      favoritesList.add(
        Dismissible(
          key: ValueKey(movie.id),
          onDismissed: (direction) {
            ref
                .read(favoriteMoviesProvider.notifier)
                .toggleMovieFavoritesStatus(movie);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${movie.originalTitle} unfaved!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
          child: FavoriteItem(
            title: movie.originalTitle,
            imgPath: movie.posterPath,
            onTapResult: () {
              openMovieDetails(movie.id);
            },
          ),
        ),
      );
    }

    for (var show in favShows) {
      favoritesList.add(
        Dismissible(
          key: ValueKey(show.id),
          onDismissed: (direction) {
            ref
                .read(favoriteShowsProvider.notifier)
                .toggleShowFavoritesStatus(show);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${show.originalName} unfaved!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
          child: FavoriteItem(
            title: show.originalName,
            imgPath: show.posterPath,
            onTapResult: () {
              openShowDetails(show.id);
            },
          ),
        ),
      );
    }

    Widget content;

    if (favMovies.isEmpty && favShows.isEmpty) {
      content = Center(
        child: Text(
          'No fav yet..',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    } else {
      content = ListView(
        children: favoritesList,
      );
    }

    if (_isLoading) {
      content = Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: content,
    );
  }
}
