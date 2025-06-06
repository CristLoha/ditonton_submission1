part of 'search_tv_bloc.dart';

sealed class SearchTvEvent extends Equatable {
  const SearchTvEvent();
}

class OnQueryTvChanged extends SearchTvEvent {
  final String query;
  const OnQueryTvChanged(this.query);
  @override
  List<Object> get props => [query];
}
