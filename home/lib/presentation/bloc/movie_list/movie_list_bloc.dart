import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/usecases/get_now_playing_movies.dart';
import 'package:home/domain/usecases/get_popular_movies.dart';
import 'package:home/domain/usecases/get_top_rated_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListEmpty()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchMovieListPopularMovies>(_onFetchPopularMovies);
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(MovieListError(failure.message));
      },
      (movies) {
        final currentState = state;
        if (currentState is MovieListHasData) {
          emit(currentState.copyWith(nowPlayingMovies: movies));
        } else {
          emit(
            MovieListHasData(
              nowPlayingMovies: movies,
              popularMovies: const [],
              topRatedMovies: const [],
            ),
          );
        }
      },
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchMovieListPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    final result = await getPopularMovies.execute();
    result.fold((failure) => emit(MovieListError(failure.message)), (movies) {
      final currentState = state;
      if (currentState is MovieListHasData) {
        emit(currentState.copyWith(popularMovies: movies));
      } else {
        emit(
          MovieListHasData(
            nowPlayingMovies: const [],
            popularMovies: movies,
            topRatedMovies: const [],
          ),
        );
      }
    });
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    final result = await getTopRatedMovies.execute();
    result.fold((failure) => emit(MovieListError(failure.message)), (movies) {
      final currentState = state;
      if (currentState is MovieListHasData) {
        emit(currentState.copyWith(topRatedMovies: movies));
      } else {
        emit(
          MovieListHasData(
            nowPlayingMovies: const [],
            popularMovies: const [],
            topRatedMovies: movies,
          ),
        );
      }
    });
  }
}
