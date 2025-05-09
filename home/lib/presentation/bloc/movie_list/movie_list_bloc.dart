import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:home/domain/usecases/get_now_playing_movies.dart';
import 'package:home/domain/usecases/get_popular_movies.dart';
import 'package:home/domain/usecases/get_top_rated_movies.dart';
// Remove this import as it's causing the conflict
// import 'package:home/presentation/bloc/popular_movies/popular_movies_bloc.dart';
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
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchMovieListPopularMovies>(_onFetchPopularMovies);  // Update this line
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
      FetchNowPlayingMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(nowPlayingState: RequestState.loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          nowPlayingState: RequestState.error,
          message: failure.message,
        ));
      },
      (movies) {
        emit(state.copyWith(
          nowPlayingState: RequestState.loaded,
          nowPlayingMovies: movies,
        ));
      },
    );
  }

  Future<void> _onFetchPopularMovies(
      FetchMovieListPopularMovies event, Emitter<MovieListState> emit) async {  // Update this line
    emit(state.copyWith(popularMoviesState: RequestState.loading));
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          popularMoviesState: RequestState.error,
          message: failure.message,
        ));
      },
      (movies) {
        emit(state.copyWith(
          popularMoviesState: RequestState.loaded,
          popularMovies: movies,
        ));
      },
    );
  }

  Future<void> _onFetchTopRatedMovies(
      FetchTopRatedMovies event, Emitter<MovieListState> emit) async {
    emit(state.copyWith(topRatedMoviesState: RequestState.loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          topRatedMoviesState: RequestState.error,
          message: failure.message,
        ));
      },
      (movies) {
        emit(state.copyWith(
          topRatedMoviesState: RequestState.loaded,
          topRatedMovies: movies,
        ));
      },
    );
  }
}