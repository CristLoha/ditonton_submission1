import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/movie.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListEmpty extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListError extends MovieListState {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieListHasData extends MovieListState {
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;

  const MovieListHasData({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
  });

  MovieListHasData copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
  }) {
    return MovieListHasData(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object?> get props => [nowPlayingMovies, popularMovies, topRatedMovies];
}
