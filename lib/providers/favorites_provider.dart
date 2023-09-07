import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';

final firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class FavoriteMoviesNotifier extends StateNotifier<List<IndividualMovie>> {
  FavoriteMoviesNotifier() : super([]);

  Future<bool> toggleMovieFavoritesStatus(IndividualMovie movie) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('fav_movies')
        .where('uid', isEqualTo: user!.uid)
        .where('mov_id', isEqualTo: movie.id)
        .get();

    final isFaved = querySnapshot.docs.isNotEmpty;

    if (isFaved) {
      state = state.where((m) => m.id != movie.id).toList();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return false;
    } else {
      CollectionReference moviesCollection = firestore.collection('fav_movies');

      await moviesCollection.add({
        'uid': user!.uid.toString(),
        'mov_id': movie.id,
        'title': movie.originalTitle,
        'img_path': movie.posterPath,
      });

      state = [...state, movie];
      return true;
    }
  }

  Future<void> fetchFromFirebase() async {
    List<IndividualMovie> movies = [];
    List<String> ids = [];

    QuerySnapshot querySnapshot = await firestore
        .collection('fav_movies')
        .where('uid', isEqualTo: user!.uid)
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      ids.add(querySnapshot.docs[i]['mov_id'].toString());
    }

    for (final id in ids) {
      IndividualMovie movie = await ApiService.getIndv(id);
      movies.add(movie);
    }

    state = movies;
  }
}

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, List<IndividualMovie>>((ref) {
  return FavoriteMoviesNotifier();
});
