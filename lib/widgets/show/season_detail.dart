import 'package:flutter/material.dart';
import 'package:movies/utils/constants.dart';
import 'package:intl/intl.dart';

class SeasonDetail extends StatelessWidget {
  const SeasonDetail({
    super.key,
    required this.title,
    required this.overview,
    required this.airDate,
    required this.vote,
    required this.img,
  });

  final String? title;
  final String? overview;
  final String? airDate;
  final String? vote;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        image: img != null
            ? DecorationImage(
                image: NetworkImage(Constants.BASE_IMG_URL + img!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.dstATop,
                ),
              )
            : null,
      ),
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  if (overview != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        overview!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Column(
                    children: [
                      if (airDate != null)
                        Text(
                          'Air Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(airDate!))}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                        ),
                      if (vote != null)
                        Text(
                          'Vote: $vote',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
