import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) : super(TvListEmpty()) {
    on<FetchOnTheAirTv>(_onFetchOnTheAirTv);
    on<FetchPopularTv>(_onFetchPopularTv);
    on<FetchTopRatedTv>(_onFetchTopRatedTv);
  }

  Future<void> _onFetchOnTheAirTv(
    FetchOnTheAirTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(TvListLoading());
    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) {
        emit(TvListError(failure.message));
      },
      (tvData) {
        final currentState = state;
        if (currentState is TvListHasData) {
          emit(currentState.copyWith(onTheAirTv: tvData));
        } else {
          emit(
            TvListHasData(onTheAirTv: tvData, popularTv: [], topRatedTv: []),
          );
        }
      },
    );
  }

  Future<void> _onFetchPopularTv(
    FetchPopularTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(TvListLoading());
    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        emit(TvListError(failure.message));
      },
      (tvData) {
        final currentState = state;
        if (currentState is TvListHasData) {
          emit(currentState.copyWith(popularTv: tvData));
        } else {
          emit(
            TvListHasData(onTheAirTv: [], popularTv: tvData, topRatedTv: []),
          );
        }
      },
    );
  }

  Future<void> _onFetchTopRatedTv(
    FetchTopRatedTv event,
    Emitter<TvListState> emit,
  ) async {
    emit(TvListLoading());
    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        emit(TvListError(failure.message));
      },
      (tvData) {
        final currentState = state;
        if (currentState is TvListHasData) {
          emit(currentState.copyWith(topRatedTv: tvData));
        } else {
          emit(
            TvListHasData(onTheAirTv: [], popularTv: [], topRatedTv: tvData),
          );
        }
      },
    );
  }
}
