import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:home/home.dart';
import 'package:equatable/equatable.dart';


part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies})
    : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        );
      },
      (moviesData) {
        emit(state.copyWith(state: RequestState.loaded, movies: moviesData));
      },
    );
  }
}
