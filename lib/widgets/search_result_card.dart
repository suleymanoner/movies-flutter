import 'package:flutter/material.dart';
import 'package:movies/constants.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.title,
    required this.imgPath,
    required this.onTapResult,
  });

  final String title;
  final String imgPath;
  final void Function() onTapResult;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapResult,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imgPath.isNotEmpty
                    ? Image.network(
                        Constants.BASE_IMG_URL + imgPath,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/broken_image.png',
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 18,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
