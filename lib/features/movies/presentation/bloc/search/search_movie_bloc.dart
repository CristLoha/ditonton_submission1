import 'package:bloc/bloc.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:rxdart/rxdart.dart';
part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies _searchMovies;
  SearchMovieBloc(this._searchMovies) : super(SearchMovieEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      emit(SearchMovieLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(SearchMovieError(failure.message));
        },
        (data) {
          emit(SearchMovieHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
  EventTransformer<Event> debounce<Event>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }
}
