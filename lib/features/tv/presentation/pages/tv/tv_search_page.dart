import 'package:core/core.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvSearchPage extends StatelessWidget {
  const TvSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  Provider.of<TvSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchTvSearch(query);
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
            Consumer<TvSearchNotifier>(
              builder: (context, data, child) {
                if (data.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return MediaCardList(media: tv, isMovie: false);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (data.state == RequestState.error) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.message, key: const Key('error_message')),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<TvSearchNotifier>(
                                context,
                                listen: false,
                              ).fetchTvSearch('');
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
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
