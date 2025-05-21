import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_watchlist_status_movie.dart';
import '../../../domain/usecases/remove_watchlist_movie.dart';
import '../../../domain/usecases/save_watchlist_movie.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';

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
  }) : super(MovieDetailEmpty()) {
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
    emit(MovieDetailLoading());
    final result = await getMovieDetail.execute(event.id);
    await result.fold(
      (failure) async {
        emit(MovieDetailError(failure.message));
      },
      (movieData) async {
        final isAdded = await getWatchListStatus.execute(event.id);
        final recResult = await getMovieRecommendations.execute(event.id);

        recResult.fold(
          (failure) {
            emit(
              MovieDetailHasData(
                movie: movieData,
                recommendations: [],
                isAddedToWatchlist: isAdded,
              ),
            );
          },
          (recommendations) {
            emit(
              MovieDetailHasData(
                movie: movieData,
                recommendations: recommendations,
                isAddedToWatchlist: isAdded,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onFetchMovieRecommendations(
    FetchMovieRecommendations event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is! MovieDetailHasData) return;
    final currentState = state as MovieDetailHasData;

    final result = await getMovieRecommendations.execute(event.id);
    result.fold(
      (failure) {
        emit(MovieDetailError(failure.message));
      },
      (moviesData) {
        emit(
          MovieDetailHasData(
            movie: currentState.movie,
            recommendations: moviesData,
            isAddedToWatchlist: currentState.isAddedToWatchlist,
          ),
        );
      },
    );
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is! MovieDetailHasData) return;
    final currentState = state as MovieDetailHasData;

    final result = await saveWatchlist.execute(currentState.movie);
    await result.fold(
      (failure) async => emit(MovieDetailError(failure.message)),
      (_) async {
        final isAdded = await getWatchListStatus.execute(currentState.movie.id);
        emit(
          currentState.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: 'Added to Watchlist',
          ),
        );
      },
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is! MovieDetailHasData) return;
    final currentState = state as MovieDetailHasData;

    final result = await removeWatchlist.execute(currentState.movie);
    await result.fold(
      (failure) async => emit(MovieDetailError(failure.message)),
      (_) async {
        final isAdded = await getWatchListStatus.execute(currentState.movie.id);
        emit(
          currentState.copyWith(
            isAddedToWatchlist: isAdded,
            watchlistMessage: 'Removed from Watchlist',
          ),
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);

    if (state is MovieDetailHasData) {
      final currentState = state as MovieDetailHasData;
      emit(currentState.copyWith(isAddedToWatchlist: isAdded));
    } else {
      emit(MovieDetailLoading());
    }
  }
}
