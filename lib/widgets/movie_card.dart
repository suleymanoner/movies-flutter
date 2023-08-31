import 'package:flutter/material.dart';
import 'package:movies/constants.dart';
import 'package:movies/models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTapMovie,
  });

  final Movie movie;
  final void Function() onTapMovie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapMovie,
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                Constants.BASE_IMG_URL + movie.posterPath,
                width: 170,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
