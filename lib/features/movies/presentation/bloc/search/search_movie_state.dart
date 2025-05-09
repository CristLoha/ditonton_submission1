part of 'search_movie_bloc.dart';

sealed class SearchMovieState extends Equatable {
  const SearchMovieState();
  
  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchMovieState {}
class SearchLoading extends SearchMovieState {}
class SearchError extends SearchMovieState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchMovieState {
  final List<Movie> result;

  const SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}