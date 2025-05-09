part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movie;
  final List<Movie> movieRecommendations;
  final RequestState movieState;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;

  const MovieDetailState({
    this.movie,
    this.movieRecommendations = const [],
    this.movieState = RequestState.empty,
    this.recommendationState = RequestState.empty,
    this.message = '',
    this.isAddedToWatchlist = false,
  });

  MovieDetailState copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    RequestState? movieState,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieState: movieState ?? this.movieState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    movieRecommendations,
    movieState,
    recommendationState,
    message,
    isAddedToWatchlist,
  ];
}
