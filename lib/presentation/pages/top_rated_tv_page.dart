import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_submission1/core/constants/text_styles.dart';
import 'package:ditonton_submission1/core/constants/values.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tv_detail_page.dart';

class TopRatedTvPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

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
                      ).pushNamed(TvDetailPage.routeName, arguments: tv.id);
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

class TvList extends StatelessWidget {
  final Tv tv;

  const TvList(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed(TvDetailPage.routeName, arguments: tv.id);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: '$baseImageUrl${tv.posterPath}',
                width: 80,
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tv.name ?? '-', style: kSubtitle),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text('${tv.voteAverage?.toStringAsFixed(1) ?? '0.0'}'),
                    ],
                  ),
                  Text(
                    tv.overview ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
