import 'package:equatable/equatable.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {}

class FetchMovieListPopularMovies extends MovieListEvent {}

class FetchTopRatedMovies extends MovieListEvent {}
