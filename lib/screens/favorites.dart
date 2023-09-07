import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/providers/favorites_provider.dart';
import 'package:movies/widgets/movie_details.dart';
import 'package:movies/widgets/search_result_card.dart';

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

    if (favMovies.isEmpty) {
      setState(() {
        _isLoading = true;
      });
      await ref.read(favoriteMoviesProvider.notifier).fetchFromFirebase();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favMovies = ref.watch(favoriteMoviesProvider);

    void openDetails(int movId) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => MovieDetails(id: movId),
      );
    }

    Widget content = ListView.builder(
      itemCount: favMovies.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(favMovies[index].id),
          onDismissed: (direction) {
            ref
                .read(favoriteMoviesProvider.notifier)
                .toggleMovieFavoritesStatus(favMovies[index]);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${favMovies[index].originalTitle} unfaved!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
          child: SearchResultCard(
            title: favMovies[index].originalTitle,
            imgPath: favMovies[index].posterPath,
            onTapResult: () {
              openDetails(favMovies[index].id);
            },
          ),
        );
      },
    );

    if (favMovies.isEmpty) {
      content = Center(
          child: Text(
        'No fav yet..',
        style: Theme.of(context).textTheme.titleLarge,
      ));
    }

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: content,
    );
  }
}
