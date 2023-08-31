import 'package:flutter/material.dart';
import 'package:movies/constants.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/detail_container_item.dart';
import 'package:url_launcher/link.dart';
import 'package:intl/intl.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
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

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: CircularProgressIndicator());

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
          Image.network(
            Constants.BASE_IMG_URL + _movie!.backdropPath,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
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
          icon: const Icon(Icons.star_border),
          onPressed: () {},
        )
      ],
    );

    return SizedBox(
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
    );
  }
}
