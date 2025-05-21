import 'package:equatable/equatable.dart';
import 'package:home/home.dart';

sealed class TvListState extends Equatable {
  const TvListState();
  @override
  List<Object?> get props => [];
}

class TvListEmpty extends TvListState {}

class TvListLoading extends TvListState {}

class TvListError extends TvListState {
  final String message;

  const TvListError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvListHasData extends TvListState {
  final List<Tv> onTheAirTv;
  final List<Tv> popularTv;
  final List<Tv> topRatedTv;

  const TvListHasData({
    this.onTheAirTv = const [],
    this.popularTv = const [],
    this.topRatedTv = const [],
  });

  TvListHasData copyWith({
    List<Tv>? onTheAirTv,
    List<Tv>? popularTv,
    List<Tv>? topRatedTv,
  }) {
    return TvListHasData(
      onTheAirTv: onTheAirTv ?? this.onTheAirTv,
      popularTv: popularTv ?? this.popularTv,
      topRatedTv: topRatedTv ?? this.topRatedTv,
    );
  }

  @override
  List<Object?> get props => [onTheAirTv, popularTv, topRatedTv];
}
