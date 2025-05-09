import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:home/home.dart';
import 'tv_list_event.dart';
import 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnTheAirTv getOnTheAirTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  TvListBloc({
    required this.getOnTheAirTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(const TvListState()) {
    on<FetchOnTheAirTv>(_onFetchOnTheAirTv);
    on<FetchPopularTv>(_onFetchPopularTv);
    on<FetchTopRatedTv>(_onFetchTopRatedTv);
  }

  Future<void> _onFetchOnTheAirTv(
      FetchOnTheAirTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(onTheAirTvState: RequestState.loading));
    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          onTheAirTvState: RequestState.error,
          message: failure.message,
        ));
      },
      (tvData) {
        emit(state.copyWith(
          onTheAirTvState: RequestState.loaded,
          onTheAirTv: tvData,
        ));
      },
    );
  }

  Future<void> _onFetchPopularTv(
      FetchPopularTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(popularTvState: RequestState.loading));
    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          popularTvState: RequestState.error,
          message: failure.message,
        ));
      },
      (tvData) {
        emit(state.copyWith(
          popularTvState: RequestState.loaded,
          popularTv: tvData,
        ));
      },
    );
  }

  Future<void> _onFetchTopRatedTv(
      FetchTopRatedTv event, Emitter<TvListState> emit) async {
    emit(state.copyWith(topRatedTvState: RequestState.loading));
    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          topRatedTvState: RequestState.error,
          message: failure.message,
        ));
      },
      (tvData) {
        emit(state.copyWith(
          topRatedTvState: RequestState.loaded,
          topRatedTv: tvData,
        ));
      },
    );
  }
}