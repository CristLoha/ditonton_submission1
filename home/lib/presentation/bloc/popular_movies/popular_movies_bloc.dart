import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import 'package:home/home.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc({required this.getPopularMovies})
      : super(const PopularMoviesState()) {
    on<FetchPopularMoviesData>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMoviesData event,
    Emitter<PopularMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getPopularMovies.execute();

    result.fold(
      (failure) {
        emit(state.copyWith(state: RequestState.error, message: failure.message));
      },
      (moviesData) {
        emit(state.copyWith(state: RequestState.loaded, movies: moviesData));
      },
    );
  }
}