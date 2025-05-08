import 'package:core/core.dart';
import 'package:ditonton_submission1/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvPage extends StatefulWidget {
  const PopularTvPage({super.key});

  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<PopularTvNotifier>(context, listen: false).fetchPopularTv();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvNotifier>(
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
                      onPressed: () => data.fetchPopularTv(),
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
