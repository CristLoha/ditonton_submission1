import 'package:equatable/equatable.dart';

sealed class TvListEvent extends Equatable {
  const TvListEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTv extends TvListEvent {}
class FetchPopularTv extends TvListEvent {}
class FetchTopRatedTv extends TvListEvent {}