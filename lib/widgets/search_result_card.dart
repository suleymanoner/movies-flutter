import 'package:flutter/material.dart';
import 'package:movies/utils/constants.dart';

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: imgPath.isNotEmpty
                  ? Image.network(
                      Constants.BASE_IMG_URL + imgPath,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/broken_image.png'),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
