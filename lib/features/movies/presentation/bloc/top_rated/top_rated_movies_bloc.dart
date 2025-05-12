import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:equatable/equatable.dart';
part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies)
    : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(TopRatedMoviesError(failure.message)),
        (data) => emit(TopRatedMoviesHasData(data)),
      );
    });
  }
}
