part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends MovieDetailEvent {
  const AddWatchlist();

  @override
  List<Object> get props => [];
}

class RemoveFromWatchlist extends MovieDetailEvent {
  const RemoveFromWatchlist();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends MovieDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class FetchMovieRecommendations extends MovieDetailEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
