import 'package:bloc_test/bloc_test.dart';
import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

    test('initial state should be empty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  group('get popular movies', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect:
          () => [PopularMoviesLoading(), PopularMoviesHasData(testMovieList)],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [loading, error] when get top rated movies is unsuccessful',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Error message')));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect:
          () => [
            PopularMoviesLoading(),
            const PopularMoviesError('Error message'),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
