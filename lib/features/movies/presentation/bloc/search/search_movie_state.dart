part of 'search_movie_bloc.dart';

sealed class SearchMovieState extends Equatable {
  const SearchMovieState();
  
  @override
  List<Object> get props => [];
}

class SearchMovieEmpty extends SearchMovieState {}
class SearchMovieLoading extends SearchMovieState {}
class SearchMovieError extends SearchMovieState {
  final String message;

  const SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchMovieState {
  final List<Movie> result;

  const SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}