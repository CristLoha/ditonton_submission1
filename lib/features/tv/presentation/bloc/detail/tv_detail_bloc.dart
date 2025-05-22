import 'package:bloc/bloc.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/entities/tv_detail.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;
  final GetTvRecommendations getTvRecommendations;
  TvDetailBloc({
    required this.getTvDetail,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getTvRecommendations,
  }) : super(TvDetailEmpty()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<FetchTvRecommendations>(_onFetchTvRecommendations);
  }

  Future<void> _onFetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(TvDetailLoading());
    final result = await getTvDetail.execute(event.id);
    await result.fold(
      (failure) async {
        emit(TvDetailError(failure.message));
      },
      (tvData) async {
        final isAdded = await getWatchListStatus.execute(event.id);
        final recResult = await getTvRecommendations.execute(event.id);

        recResult.fold(
          (failure) {
            emit(
              TvDetailHasData(
                tv: tvData,
                recommendations: [],
                isAddedToWatchlist: isAdded,
              ),
            );
          },
          (recommendations) {
            emit(
              TvDetailHasData(
                tv: tvData,
                recommendations: recommendations,
                isAddedToWatchlist: isAdded,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    if (state is! TvDetailHasData) return;
    final currentState = state as TvDetailHasData;

    final result = await saveWatchlist.execute(currentState.tv);
    await result.fold((failure) async => emit(TvDetailError(failure.message)), (
      _,
    ) async {
      final isAdded = await getWatchListStatus.execute(currentState.tv.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: TvLocalDataSourceImpl.watchlistAddSuccessMessage,
        ),
      );
    });
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    if (state is! TvDetailHasData) return;
    final currentState = state as TvDetailHasData;

    final result = await removeWatchlist.execute(currentState.tv);
    await result.fold((failure) async => emit(TvDetailError(failure.message)), (
      _,
    ) async {
      final isAdded = await getWatchListStatus.execute(currentState.tv.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: TvLocalDataSourceImpl.watchlistRemoveSuccessMessage,
        ),
      );
    });
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<TvDetailState> emit,
  ) async {
    if (state is! TvDetailHasData) return;
    final currentState = state as TvDetailHasData;

    final isAdded = await getWatchListStatus.execute(currentState.tv.id);
    emit(currentState.copyWith(isAddedToWatchlist: isAdded));
  }

  Future<void> _onFetchTvRecommendations(
    FetchTvRecommendations event,
    Emitter<TvDetailState> emit,
  ) async {
    if (state is! TvDetailHasData) return;
    final currentState = state as TvDetailHasData;

    final result = await getTvRecommendations.execute(event.id);
    result.fold(
      (failure) {
        emit(
          TvDetailHasData(
            tv: currentState.tv,
            recommendations: [],
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ),
        );
      },
      (recommendations) {
        emit(
          TvDetailHasData(
            tv: currentState.tv,
            recommendations: recommendations,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ),
        );
      },
    );
  }
}
