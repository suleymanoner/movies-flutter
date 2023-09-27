import 'package:flutter/material.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/utils/constants.dart';

class ShowCard extends StatelessWidget {
  const ShowCard({
    super.key,
    required this.show,
    required this.onTapShow,
  });

  final TvShow show;
  final void Function() onTapShow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapShow,
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: show.posterPath.isNotEmpty
                  ? Image.network(
                      Constants.BASE_IMG_URL + show.posterPath,
                      width: 170,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/broken_image.png',
                      width: 170,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    show.name,
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
