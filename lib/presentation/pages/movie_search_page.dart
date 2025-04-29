import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:ditonton_submission1/presentation/provider/movie_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchPage extends StatelessWidget {
  static const routeName = '/movie-search';

  const MovieSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  Provider.of<MovieSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchMovieSearch(query);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Consumer<MovieSearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return MediaCardList(media: movie, isMovie: true);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
