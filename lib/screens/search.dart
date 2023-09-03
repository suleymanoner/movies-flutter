import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/api_service.dart';
import 'package:movies/widgets/movie_details.dart';
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
  List<Movie> searchResults = [];
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

      final queryResults = await ApiService.searchMovie(query);

      setState(() {
        searchResults = queryResults;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errMsg = 'Failed to load movie!';
        _isLoading = false;
      });
    }
  }

  void _openDetails(int movId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => MovieDetails(id: movId),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (ctx, index) {
        if (_errMsg != '') {
          return Center(child: Text(_errMsg));
        }
        return SearchResultCard(
          title: searchResults[index].originalTitle,
          imgPath: searchResults[index].posterPath,
          onTapResult: () {
            _openDetails(searchResults[index].id);
          },
        );
      },
    );

    if (searchResults.isEmpty) {
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
          Padding(
            padding: const EdgeInsets.all(14),
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
