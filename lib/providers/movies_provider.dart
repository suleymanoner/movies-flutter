import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';

List<Movie> removeDuplicates(List<Movie> newMovies, dynamic state) {
  final uniqueMovies = <Movie>[];

  for (final newMovie in newMovies) {
    if (!state.any((existingMovie) => existingMovie.id == newMovie.id)) {
      uniqueMovies.add(newMovie);
    }
  }

  return uniqueMovies;
}

class NowPlayingMovieNotifier extends StateNotifier<List<Movie>> {
  NowPlayingMovieNotifier() : super([]);

  Future<void> fetchNowPlayingMovies(int page) async {
    final fetchedNowPlayingMovies =
        await ApiService.fetchMoviesByType('now_playing', page);

    final uniqueFetchedMovies =
        removeDuplicates(fetchedNowPlayingMovies, state);
    state = [...state, ...uniqueFetchedMovies];
  }
}

final nowPlayingMoviesProvider =
    StateNotifierProvider<NowPlayingMovieNotifier, List<Movie>>((ref) {
  return NowPlayingMovieNotifier();
});

class TopRatedMovieNotifier extends StateNotifier<List<Movie>> {
  TopRatedMovieNotifier() : super([]);

  Future<void> fetchTopRatedMovies(int page) async {
    final fetchedTopRatedMovies =
        await ApiService.fetchMoviesByType('top_rated', page);

    final uniqueFetchedMovies = removeDuplicates(fetchedTopRatedMovies, state);
    state = [...state, ...uniqueFetchedMovies];
  }
}

final topRatedMoviesProvider =
    StateNotifierProvider<TopRatedMovieNotifier, List<Movie>>((ref) {
  return TopRatedMovieNotifier();
});

class UpcomingMovieNotifier extends StateNotifier<List<Movie>> {
  UpcomingMovieNotifier() : super([]);

  Future<void> fetchUpcomingMovies(int page) async {
    final fetchedUpcomingMovies =
        await ApiService.fetchMoviesByType('upcoming', page);

    final uniqueFetchedMovies = removeDuplicates(fetchedUpcomingMovies, state);
    state = [...state, ...uniqueFetchedMovies];
  }
}

final upcomingMoviesProvider =
    StateNotifierProvider<UpcomingMovieNotifier, List<Movie>>((ref) {
  return UpcomingMovieNotifier();
});

class PopularMovieNotifier extends StateNotifier<List<Movie>> {
  PopularMovieNotifier() : super([]);

  Future<void> fetchPopularMovies(int page) async {
    final fetchedPopularMovies =
        await ApiService.fetchMoviesByType('popular', page);

    final uniqueFetchedMovies = removeDuplicates(fetchedPopularMovies, state);
    state = [...state, ...uniqueFetchedMovies];
  }
}

final popularMoviesProvider =
    StateNotifierProvider<PopularMovieNotifier, List<Movie>>((ref) {
  return PopularMovieNotifier();
});
