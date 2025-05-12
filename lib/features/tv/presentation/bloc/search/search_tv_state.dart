part of 'search_tv_bloc.dart';

sealed class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object> get props => [];
}

final class SearchTvEmpty extends SearchTvState {}

final class SearchTvLoading extends SearchTvState {}

final class SearchTvError extends SearchTvState {
  final String message;
  const SearchTvError(this.message);
  @override
  List<Object> get props => [message];
}

final class SearchTvHasData extends SearchTvState {
  final List<Tv> result;
  const SearchTvHasData(this.result);
  @override
  List<Object> get props => [result];
}
