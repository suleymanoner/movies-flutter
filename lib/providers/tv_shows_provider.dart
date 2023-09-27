import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/services/api_service.dart';

List<TvShow> removeDuplicates(List<TvShow> newShows, dynamic state) {
  final uniqueShows = <TvShow>[];

  for (final newShow in newShows) {
    if (!state.any((existingShow) => existingShow.id == newShow.id)) {
      uniqueShows.add(newShow);
    }
  }

  return uniqueShows;
}

class OnTheAirShowsNotifier extends StateNotifier<List<TvShow>> {
  OnTheAirShowsNotifier() : super([]);

  Future<void> fetchOnTheAirShows(int page) async {
    final fetchedOnTheAirShows =
        await ApiService.fetchTvShowsByType('on_the_air', page);

    final uniqueFetchedShows = removeDuplicates(fetchedOnTheAirShows, state);
    state = [...state, ...uniqueFetchedShows];
  }
}

final onTheAirProvider =
    StateNotifierProvider<OnTheAirShowsNotifier, List<TvShow>>((ref) {
  return OnTheAirShowsNotifier();
});

class TopRatedShowsNotifier extends StateNotifier<List<TvShow>> {
  TopRatedShowsNotifier() : super([]);

  Future<void> fetchTopRatedShows(int page) async {
    final fetchedTopRatedShows =
        await ApiService.fetchTvShowsByType('top_rated', page);

    final uniqueFetchedShows = removeDuplicates(fetchedTopRatedShows, state);
    state = [...state, ...uniqueFetchedShows];
  }
}

final topRatedShowsProvider =
    StateNotifierProvider<TopRatedShowsNotifier, List<TvShow>>((ref) {
  return TopRatedShowsNotifier();
});

class PopularShowsNotifier extends StateNotifier<List<TvShow>> {
  PopularShowsNotifier() : super([]);

  Future<void> fetchPopularShows(int page) async {
    final fetchedPopularShows =
        await ApiService.fetchTvShowsByType('popular', page);

    final uniqueFetchedShows = removeDuplicates(fetchedPopularShows, state);
    state = [...state, ...uniqueFetchedShows];
  }
}

final popularShowsProvider =
    StateNotifierProvider<PopularShowsNotifier, List<TvShow>>((ref) {
  return PopularShowsNotifier();
});

class AiringTodayShowsNotifier extends StateNotifier<List<TvShow>> {
  AiringTodayShowsNotifier() : super([]);

  Future<void> fetchUAiringShows(int page) async {
    final fetchedAiringShows =
        await ApiService.fetchTvShowsByType('airing_today', page);

    final uniqueFetchedShows = removeDuplicates(fetchedAiringShows, state);
    state = [...state, ...uniqueFetchedShows];
  }
}

final airingTodayShowsProvider =
    StateNotifierProvider<AiringTodayShowsNotifier, List<TvShow>>((ref) {
  return AiringTodayShowsNotifier();
});
