import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/constants.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/providers/favorites_provider.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/detail_container_item.dart';
import 'package:url_launcher/link.dart';
import 'package:intl/intl.dart';

class MovieDetails extends ConsumerStatefulWidget {
  const MovieDetails({
    super.key,
    required this.id,
  });

  final int id;

  @override
  ConsumerState<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends ConsumerState<MovieDetails> {
  IndividualMovie? _movie;
  bool _isLoading = true;
  String _errMsg = '';

  @override
  void initState() {
    super.initState();
    _getIndvMovie();
  }

  Future<void> _getIndvMovie() async {
    try {
      final indvMovie = await ApiService.getIndv(widget.id.toString());
      setState(() {
        _movie = indvMovie;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errMsg = 'Failed to load movie!';
      });
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

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: CircularProgressIndicator());
    final favMovies = ref.watch(favoriteMoviesProvider);
    final isFaved = favMovies.any((movie) => movie.id == _movie?.id);

    if (_movie != null) {
      DateTime date = DateTime.now();

      if (_movie!.releaseDate.isNotEmpty) {
        date = DateTime.parse(_movie!.releaseDate);
      }

      String formattedBudget = NumberFormat.compactCurrency(
        locale: 'en_US',
        symbol: '\$',
      ).format(_movie!.budget);

      String formattedRevenue = NumberFormat.compactCurrency(
        locale: 'en_US',
        symbol: '\$',
      ).format(_movie!.revenue);

      content = Column(
        children: [
          Container(
            child: _movie!.posterPath.isNotEmpty
                ? Image.network(
                    Constants.BASE_IMG_URL + _movie!.backdropPath,
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
          const SizedBox(height: 8),
          Text(
            _movie!.originalTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          _movie!.tagline.isNotEmpty
              ? Text(
                  "'${_movie!.tagline}'",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              _movie!.overview,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  _movie!.releaseDate.isNotEmpty
                      ? DetailContainerItem(
                          title: 'Release Date',
                          text: DateFormat.yMMMMd('en_US').format(date),
                        )
                      : const SizedBox(height: 4),
                  DetailContainerItem(
                    title: 'Vote',
                    text: _movie!.voteAverage.toStringAsFixed(1),
                  ),
                ],
              ),
              Column(
                children: [
                  DetailContainerItem(
                    title: 'Budget',
                    text: formattedBudget,
                  ),
                  const SizedBox(height: 4),
                  DetailContainerItem(
                    title: 'Revenue',
                    text: formattedRevenue,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: _movie!.homepage.isNotEmpty
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              Link(
                target: LinkTarget.blank,
                uri: Uri.parse(Constants.IMDB_BASE_URL + _movie!.imdbId),
                builder: (ctx, followLink) => ElevatedButton(
                  onPressed: followLink,
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: const MaterialStatePropertyAll(
                          Color.fromRGBO(243, 206, 19, 1),
                        ),
                      ),
                  child: const Text('IMDb'),
                ),
              ),
              _movie!.homepage.isNotEmpty
                  ? Link(
                      target: LinkTarget.blank,
                      uri: Uri.parse(_movie!.homepage),
                      builder: (ctx, followLink) => ElevatedButton(
                        onPressed: followLink,
                        style: Theme.of(context).elevatedButtonTheme.style!,
                        child: const Text('Website'),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      );
    }

    if (_errMsg.isNotEmpty) {
      content = Center(
          child: Text(
        _errMsg,
        style: Theme.of(context).textTheme.titleLarge,
      ));
    }

    final bottomSheetBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          onPressed: () {
            final wasAdded = ref
                .read(favoriteMoviesProvider.notifier)
                .toggleMovieFavoritesStatus(_movie!);

            _showDialog(wasAdded
                ? '${_movie!.originalTitle} faved!'
                : '${_movie!.originalTitle} removed!');
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              );
            },
            child: Icon(
              isFaved ? Icons.star : Icons.star_border,
              key: ValueKey(isFaved),
            ),
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: double.infinity,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                children: [
                  bottomSheetBar,
                  content,
                ],
              )),
      ),
    );
  }
}
