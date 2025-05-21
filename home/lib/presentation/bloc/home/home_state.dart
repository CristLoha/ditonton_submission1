
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool showMovies;

  const HomeState({this.showMovies = true});

  HomeState copyWith({bool? showMovies}) {
    return HomeState(
      showMovies: showMovies ?? this.showMovies,
    );
  }

  @override
  List<Object> get props => [showMovies];
}