part of 'tv_detail_bloc.dart';

sealed class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailHasData({
    required this.tv,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  TvDetailHasData copyWith({
    TvDetail? tv,
    List<Tv>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailHasData(
      tv: tv ?? this.tv,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    tv,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
