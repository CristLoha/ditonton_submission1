import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  context.read<SearchTvBloc>().add(OnQueryChanged(query));
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
            BlocBuilder<SearchTvBloc, SearchTvState>(
              builder: (context, state) {
                if (state is SearchTvLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchTvHasData) {
                  final result = state.result;
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
                } else if (state is SearchTvError) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message, key: const Key('error_message')),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              context.read<SearchTvBloc>().add(
                                OnQueryChanged(''),
                              );
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
