part of 'popular_movies_bloc.dart';

class PopularMoviesState extends Equatable {
  final List<Movie> movies;
  final RequestState state;
  final String message;

  const PopularMoviesState({
    this.movies = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  PopularMoviesState copyWith({
    List<Movie>? movies,
    RequestState? state,
    String? message,
  }) {
    return PopularMoviesState(
      movies: movies ?? this.movies,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [movies, state, message];
}