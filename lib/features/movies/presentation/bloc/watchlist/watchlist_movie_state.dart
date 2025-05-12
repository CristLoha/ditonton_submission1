import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/movie.dart';

class WatchlistMovieState extends Equatable {
  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  const WatchlistMovieState({
    required this.watchlistMovies,
    required this.watchlistState,
    required this.message,
  });

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  factory WatchlistMovieState.initial() => const WatchlistMovieState(
        watchlistMovies: [],
        watchlistState: RequestState.empty,
        message: '',
      );

  @override
  List<Object> get props => [watchlistMovies, watchlistState, message];
}
