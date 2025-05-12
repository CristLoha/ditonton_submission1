import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../../domain/usecases/get_watchlist_movies.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';



class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies}) 
      : super(WatchlistMovieState.initial()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.loading));

      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(state.copyWith(
          watchlistState: RequestState.error,
          message: failure.message,
        )),
        (movies) => emit(state.copyWith(
          watchlistState: RequestState.loaded,
          watchlistMovies: movies,
        )),
      );
    });
  }
}