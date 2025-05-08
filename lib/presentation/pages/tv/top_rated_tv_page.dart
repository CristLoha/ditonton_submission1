import 'package:core/core.dart';
import 'package:ditonton_submission1/presentation/provider/tv/top_rated_tv_notifier.dart';

import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTvPage extends StatefulWidget {

  const TopRatedTvPage({super.key});

  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final notifier = Provider.of<TopRatedTvNotifier>(context, listen: false);
      if (notifier.state == RequestState.empty) {
        notifier.fetchTopRatedTv();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.message),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => data.fetchTopRatedTv(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (data.state == RequestState.loaded) {
              if (data.tv.isEmpty) {
                return Center(child: Text('No TV shows found'));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tv[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(tvDetailRoute, arguments: tv.id);
                    },
                    child: MediaCardList(media: tv, isMovie: false),
                  );
                },
                itemCount: data.tv.length,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
