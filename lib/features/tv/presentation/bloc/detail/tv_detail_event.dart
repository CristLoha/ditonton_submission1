part of 'tv_detail_bloc.dart';

sealed class TvDetailEvent extends Equatable {
  const TvDetailEvent();
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class FetchTvRecommendations extends TvDetailEvent {
  final int id;

  const FetchTvRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
