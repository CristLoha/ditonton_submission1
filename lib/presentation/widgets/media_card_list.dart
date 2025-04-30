import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_submission1/core/constants/text_styles.dart';
import 'package:ditonton_submission1/core/constants/values.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';

class MediaCardList extends StatelessWidget {
  final dynamic media;
  final bool isMovie;

  const MediaCardList({required this.media, required this.isMovie, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            isMovie ? MovieDetailPage.routeName : TvDetailPage.routeName,
            arguments: isMovie ? media.id : media.id,
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMovie ? media.title ?? '-' : media.name ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      media.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl:
                      media.posterPath != null && media.posterPath.isNotEmpty
                          ? '$baseImageUrl${media.posterPath}'
                          : 'https://via.placeholder.com/500x750?text=No+Image',
                  width: 80,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
