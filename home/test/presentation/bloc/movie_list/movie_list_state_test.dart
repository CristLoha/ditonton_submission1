import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';

void main() {
  final testMovie = Movie(
    adult: false,
    backdropPath: 'path',
    genreIds: [1],
    id: 1,
    originalTitle: 'Test Movie',
    overview: 'Test Overview',
    popularity: 1,
    posterPath: 'path',
    releaseDate: '2024',
    title: 'Test',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  group('MovieListHasData', () {
    test('copyWith should update specified fields only', () {
      final initialState = MovieListHasData(
        nowPlayingMovies: [testMovie],
        popularMovies: [],
        topRatedMovies: [],
      );

      final updatedState = initialState.copyWith(
        popularMovies: [testMovie],
        topRatedMovies: [testMovie],
      );

      expect(updatedState.nowPlayingMovies, initialState.nowPlayingMovies);
      expect(updatedState.popularMovies, [testMovie]);
      expect(updatedState.topRatedMovies, [testMovie]);
    });

    test('copyWith with no parameters should return same state', () {
      final state = MovieListHasData(
        nowPlayingMovies: [testMovie],
        popularMovies: [testMovie],
        topRatedMovies: [testMovie],
      );

      final result = state.copyWith();

      expect(result, state);
    });
  });
}