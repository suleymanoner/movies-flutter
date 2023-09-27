import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/show_details.dart';
import 'package:movies/widgets/movie/movie_details.dart';
import 'package:movies/widgets/carousel_item.dart';

class MovieCarouselItem extends StatelessWidget {
  const MovieCarouselItem({
    super.key,
    required this.title,
    required this.onTapTitle,
    required this.list,
    this.isMovie = true,
  });

  final String title;
  final void Function() onTapTitle;
  final List list;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTapTitle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith()),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        CarouselItem(
          movies: list,
          onTapMovie: (id) {
            isMovie
                ? showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) => MovieDetails(id: id),
                  )
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ShowDetailsScreen(id: id);
                    },
                  ));
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
