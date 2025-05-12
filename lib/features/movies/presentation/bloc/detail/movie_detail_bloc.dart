import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:home/home.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_watchlist_status_movie.dart';
import '../../../domain/usecases/remove_watchlist_movie.dart';
import '../../../domain/usecases/save_watchlist_movie.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetWatchListStatusMovie getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getMovieRecommendations,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<FetchMovieRecommendations>(_onFetchMovieRecommendations);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.loading));
    final result = await getMovieDetail.execute(event.id);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            movieState: RequestState.error,
            message: failure.message,
          ),
        );
      },
      (movieData) {
        emit(
          state.copyWith(
            movieState: RequestState.loaded,
            movie: movieData,
            recommendationState: RequestState.loading,
          ),
        );
        add(FetchMovieRecommendations(event.id));
      },
    );
  }

  Future<void> _onFetchMovieRecommendations(
    FetchMovieRecommendations event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getMovieRecommendations.execute(event.id);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            recommendationState: RequestState.error,
            message: failure.message,
          ),
        );
      },
      (moviesData) {
        emit(
          state.copyWith(
            recommendationState: RequestState.loaded,
            movieRecommendations: moviesData,
          ),
        );
      },
    );
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state.movie == null) return;

    final result = await saveWatchlist.execute(state.movie!);

    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => throw UnimplementedError());
      emit(state.copyWith(message: failure.message));
    } else {
      final successMessage = result.fold(
        (_) => throw UnimplementedError(),
        (msg) => msg,
      );

      emit(
        state.copyWith(
          message: successMessage,
          movie: state.movie,
          movieRecommendations: state.movieRecommendations,
          movieState: state.movieState,
          recommendationState: state.recommendationState,
        ),
      );

      final isAdded = await getWatchListStatus.execute(state.movie!.id);


      if (emit.isDone) return;

      emit(
        state.copyWith(
          message: successMessage,
          isAddedToWatchlist: isAdded,
          movie: state.movie,
          movieRecommendations: state.movieRecommendations,
          movieState: state.movieState,
          recommendationState: state.recommendationState,
        ),
      );
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state.movie == null) return;

    final result = await removeWatchlist.execute(state.movie!);
    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => throw UnimplementedError());
      emit(state.copyWith(message: failure.message));
    } else {
      final successMessage = result.fold(
        (_) => throw UnimplementedError(),
        (msg) => msg,
      );

      emit(
        state.copyWith(
          message: successMessage,
          movie: state.movie,
          movieRecommendations: state.movieRecommendations,
          movieState: state.movieState,
          recommendationState: state.recommendationState,
        ),
      );

      final isAdded = await getWatchListStatus.execute(state.movie!.id);
      if (emit.isDone) return;

      emit(
        state.copyWith(
          message: successMessage,
          isAddedToWatchlist: isAdded,
          movie: state.movie,
          movieRecommendations: state.movieRecommendations,
          movieState: state.movieState,
          recommendationState: state.recommendationState,
        ),
      );
    }
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
