import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/providers/favorites_provider.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:movies/widgets/show/genre_item.dart';
import 'package:movies/widgets/show/season_detail.dart';

class ShowDetailsScreen extends ConsumerStatefulWidget {
  const ShowDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  ConsumerState<ShowDetailsScreen> createState() {
    return _ShowDetailsState();
  }
}

class _ShowDetailsState extends ConsumerState<ShowDetailsScreen> {
  IndividualTvShow? _show;

  @override
  void initState() {
    super.initState();
    _getIndvShow();
  }

  Future<void> _getIndvShow() async {
    try {
      final show = await ApiService.fetchIndvTvShow(widget.id.toString());
      setState(() {
        _show = show;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _openDetails(int index) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SeasonDetail(
        title: _show!.seasons[index]['name'],
        overview: _show!.seasons[index]['overview'],
        airDate: _show!.seasons[index]['air_date'],
        vote: _show!.seasons[index]['vote_average'].toString(),
        img: _show!.seasons[index]['poster_path'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: CircularProgressIndicator());
    final favShows = ref.watch(favoriteShowsProvider);
    final isFaved = favShows.any((show) => show.id == _show?.id);

    if (_show != null) {
      DateTime firstAirDate = DateTime.now();
      DateTime lastAirDate = DateTime.now();
      DateTime lastEpisodeAirDate = DateTime.now();

      if (_show!.firstAirDate.isNotEmpty) {
        firstAirDate = DateTime.parse(_show!.firstAirDate);
      }

      if (_show!.lastAirDate.isNotEmpty) {
        lastAirDate = DateTime.parse(_show!.lastAirDate);
      }

      if (_show!.lastEpisodeToAir['air_date'] != null) {
        lastEpisodeAirDate =
            DateTime.parse(_show!.lastEpisodeToAir['air_date']);
      }

      content = SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _show!.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      _show!.createdBy.isNotEmpty
                          ? Text(
                              'Created by: ${_show!.createdBy[0]['name']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            )
                          : const SizedBox(height: 6),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final wasAdded = ref
                            .read(favoriteShowsProvider.notifier)
                            .toggleShowFavoritesStatus(_show!);

                        _showDialog(await wasAdded
                            ? '${_show!.originalName} faved!'
                            : '${_show!.originalName} removed!');
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns:
                                Tween(begin: 0.8, end: 1.0).animate(animation),
                            child: child,
                          );
                        },
                        child: Icon(
                          isFaved ? Icons.star : Icons.star_border,
                          key: ValueKey(isFaved),
                        ),
                      ),
                    ),
                    Text(
                      _show!.voteAverage.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: _show!.backdropPath.isNotEmpty
                  ? Image.network(
                      Constants.BASE_IMG_URL + _show!.backdropPath,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/broken_image.png',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
            ),
            if (_show!.tagline.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '* ${_show!.tagline} *',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            if (_show!.overview.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text(
                  _show!.overview,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Start'),
                    Text(
                      DateFormat.yMMMMd('en_US').format(firstAirDate),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('End'),
                    Text(
                      DateFormat.yMMMMd('en_US').format(lastAirDate),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (_show!.genres.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _show!.genres
                      .map((e) => GenreItem(name: e['name']))
                      .toList(),
                ),
              ),
            const SizedBox(height: 15),
            if (_show!.lastEpisodeToAir['still_path'] != null)
              Stack(
                children: [
                  Image.network(
                    Constants.BASE_IMG_URL +
                        _show!.lastEpisodeToAir['still_path'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      color: Color.fromARGB(205, 255, 140, 140),
                      width: 150,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Text(
                                'Last episode: ${_show!.lastEpisodeToAir['name']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              if (_show!
                                  .lastEpisodeToAir['overview'].isNotEmpty)
                                Text(
                                  '"${_show!.lastEpisodeToAir['overview']}"',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.start,
                                ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    const TextSpan(text: 'Season: '),
                                    TextSpan(
                                      text: _show!
                                          .lastEpisodeToAir['season_number']
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    const TextSpan(text: 'Episode: '),
                                    TextSpan(
                                      text: _show!
                                          .lastEpisodeToAir['episode_number']
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    const TextSpan(text: 'Vote: '),
                                    TextSpan(
                                      text: _show!
                                          .lastEpisodeToAir['vote_average']
                                          .toStringAsFixed(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (_show!.lastEpisodeToAir['runtime'] != null)
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Time: '),
                                      TextSpan(
                                        text:
                                            '${_show!.lastEpisodeToAir['runtime']} min',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMd().format(lastEpisodeAirDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            if (_show!.productionCompanies.isNotEmpty)
              Text(
                'Production Companies',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            const SizedBox(height: 6),
            Column(
              children: _show!.productionCompanies
                  .map((e) => Text(
                        e['name'],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 4),
            if (_show!.seasons.isNotEmpty)
              Text(
                'Seasons',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            const SizedBox(height: 10),
            GridView.builder(
              primary: false,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: _show!.seasons.length,
              itemBuilder: (context, index) {
                if (_show!.seasons[index]['poster_path'] != null) {
                  return GestureDetector(
                    onTap: () {
                      _openDetails(index);
                    },
                    child: Image.network(
                      Constants.BASE_IMG_URL +
                          _show!.seasons[index]['poster_path'],
                      width: 200,
                      height: 200,
                    ),
                  );
                } else if (_show!.posterPath.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      _openDetails(index);
                    },
                    child: Image.network(
                      Constants.BASE_IMG_URL + _show!.posterPath,
                      width: 200,
                      height: 200,
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      _openDetails(index);
                    },
                    child: Image.asset(
                      'assets/images/broken_image.png',
                      width: 200,
                      height: 200,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: content,
        ),
      ),
    );
  }
}
