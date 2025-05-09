import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import 'package:home/home.dart';

class TvListState extends Equatable {
  final List<Tv> onTheAirTv;
  final RequestState onTheAirTvState;
  final List<Tv> popularTv;
  final RequestState popularTvState;
  final List<Tv> topRatedTv;
  final RequestState topRatedTvState;
  final String message;

  const TvListState({
    this.onTheAirTv = const [],
    this.onTheAirTvState = RequestState.empty,
    this.popularTv = const [],
    this.popularTvState = RequestState.empty,
    this.topRatedTv = const [],
    this.topRatedTvState = RequestState.empty,
    this.message = '',
  });

  TvListState copyWith({
    List<Tv>? onTheAirTv,
    RequestState? onTheAirTvState,
    List<Tv>? popularTv,
    RequestState? popularTvState,
    List<Tv>? topRatedTv,
    RequestState? topRatedTvState,
    String? message,
  }) {
    return TvListState(
      onTheAirTv: onTheAirTv ?? this.onTheAirTv,
      onTheAirTvState: onTheAirTvState ?? this.onTheAirTvState,
      popularTv: popularTv ?? this.popularTv,
      popularTvState: popularTvState ?? this.popularTvState,
      topRatedTv: topRatedTv ?? this.topRatedTv,
      topRatedTvState: topRatedTvState ?? this.topRatedTvState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    onTheAirTv,
    onTheAirTvState,
    popularTv,
    popularTvState,
    topRatedTv,
    topRatedTvState,
    message,
  ];
}