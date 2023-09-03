import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/models/movie.dart';

class FavoriteMoviesNotifier extends StateNotifier<List<IndividualMovie>> {
  FavoriteMoviesNotifier() : super([]);

  bool toggleMovieFavoritesStatus(IndividualMovie movie) {
    final isFaved = state.any((m) => m.id == movie.id);

    if (isFaved) {
      state = state.where((m) => m.id != movie.id).toList();
      return false;
    } else {
      state = [...state, movie];
      return true;
    }
  }
}

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, List<IndividualMovie>>((ref) {
  return FavoriteMoviesNotifier();
});
