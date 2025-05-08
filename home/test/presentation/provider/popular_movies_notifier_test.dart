import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/usecases/get_popular_movies.dart';
import 'package:home/presentation/provider/popular_movies_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import 'movie_list_notifier_test.mocks.dart';

@GenerateMocks([PopularMoviesNotifier, GetPopularMovies])
void main() {
  late PopularMoviesNotifier provider;
  late MockGetPopularMovies mockGetPopularMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularMovies = MockGetPopularMovies();
    provider = PopularMoviesNotifier(mockGetPopularMovies)..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('get popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchPopularMovies();
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        // act
        await provider.fetchPopularMovies();
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.movies, testMovieList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularMovies();
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
