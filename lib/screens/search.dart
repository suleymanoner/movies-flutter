import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/tv_show.dart';
import 'package:movies/screens/show_details.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/utils/constants.dart';
import 'package:movies/widgets/movie/movie_details.dart';
import 'package:movies/widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final queryController = TextEditingController();
  List<Movie> searchMovieResults = [];
  List<TvShow> searchShowResults = [];

  bool _isLoading = false;
  String _errMsg = '';

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  Future<void> _searchMovie(String query) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final movieResults = await ApiService.searchMovie(query);
      final showResults = await ApiService.searchShow(query);

      setState(() {
        searchMovieResults = movieResults;
        searchShowResults = showResults;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errMsg = 'Failed to load movie!';
        _isLoading = false;
      });
    }
  }

  void _openMovieDetails(int movId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MovieDetails(id: movId),
    );
  }

  void _openShowDetails(int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ShowDetailsScreen(id: id);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: searchMovieResults.length,
            itemBuilder: (ctx, index) {
              if (_errMsg != '') {
                return Center(child: Text(_errMsg));
              }

              return SearchResultCard(
                  title: searchMovieResults[index].originalTitle,
                  imgPath: searchMovieResults[index].posterPath,
                  onTapResult: () {
                    _openMovieDetails(searchMovieResults[index].id);
                  });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchShowResults.length,
            itemBuilder: (ctx, index) {
              if (_errMsg != '') {
                return Center(child: Text(_errMsg));
              }

              return SearchResultCard(
                  title: searchShowResults[index].originalName,
                  imgPath: searchShowResults[index].posterPath,
                  onTapResult: () {
                    _openShowDetails(searchShowResults[index].id);
                  });
            },
          ),
        ),
      ],
    );

    if (searchMovieResults.isEmpty && searchShowResults.isEmpty) {
      content = Center(
        child: Text(
          'No results..',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 15,
              ),
              child: TextField(
                controller: queryController,
                onChanged: (value) {
                  _searchMovie(queryController.text);
                },
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  label: Text('Search..'),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _isLoading ? const CircularProgressIndicator() : content,
            ),
          ),
        ],
      ),
    );
  }
}
