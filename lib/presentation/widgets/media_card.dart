import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final dynamic media;
  final bool isMovie;

  const MediaCard({super.key, required this.media, required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: '$baseImageUrl${media.posterPath}',
              width: 80,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMovie ? media.title ?? '-' : media.name ?? '-',
                  style: kSubtitle,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${media.voteAverage?.toStringAsFixed(1) ?? '0.0'}'),
                  ],
                ),
                Text(
                  media.overview ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
