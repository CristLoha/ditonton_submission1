import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entities/genre.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../bloc/detail/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  MovieDetailPageState createState() => MovieDetailPageState();
}

class MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieDetailBloc>()
          ..add(FetchMovieDetail(widget.id))
          ..add(LoadWatchlistStatus(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailError) {
            return Center(child: Text(state.message));
          } else if (state is MovieDetailHasData) {
            return DetailContent(
              state.movie,
              state.recommendations,
              state.isAddedToWatchlist,
              onWatchlistButtonPressed: (movie, isAddedWatchlist) {
                if (isAddedWatchlist) {
                  context.read<MovieDetailBloc>().add(
                    RemoveFromWatchlist(movie),
                  );
                } else {
                  context.read<MovieDetailBloc>().add(AddWatchlist(movie));
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  final Function(MovieDetail, bool) onWatchlistButtonPressed;

  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    required this.onWatchlistButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieDetailBloc, MovieDetailState>(
      listenWhen: (previous, current) {
        if (current is MovieDetailHasData) {
          return current.watchlistMessage.isNotEmpty;
        }
        return false;
      },
      listener: (context, state) {
        if (state is MovieDetailHasData && state.watchlistMessage.isNotEmpty) {
          CustomSnackbar.show(context, state.watchlistMessage);
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            width: MediaQuery.of(context).size.width,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: kRichBlack,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.title, style: kHeading5),
                              FilledButton(
                                onPressed:
                                    () => onWatchlistButtonPressed(
                                      movie,
                                      isAddedWatchlist,
                                    ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Text(_showGenres(movie.genres)),
                              Text(_showDuration(movie.runtime)),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: movie.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder:
                                        (context, index) => const Icon(
                                          Icons.star,
                                          color: kMikadoYellow,
                                        ),
                                    itemSize: 24,
                                  ),
                                  Text('${movie.voteAverage}'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text('Overview', style: kHeading6),
                              Text(movie.overview),
                              const SizedBox(height: 16),
                              Text('Recommendations', style: kHeading6),
                              if (recommendations.isNotEmpty)
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final recommendation =
                                          recommendations[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              movieDetailRoute,
                                              arguments: recommendation.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                            child: SizedBox(
                                              width: 100,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${recommendation.posterPath}',
                                                placeholder:
                                                    (
                                                      context,
                                                      url,
                                                    ) => const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: recommendations.length,
                                  ),
                                )
                              else
                                const Center(
                                  child: Text('No recommendations available'),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: kRichBlack,
                foregroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
