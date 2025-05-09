import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ToggleTab extends HomeEvent {
  final bool showMovies;

  const ToggleTab(this.showMovies);

  @override
  List<Object> get props => [showMovies];
}