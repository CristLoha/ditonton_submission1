import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/presentation/provider/movies/top_rated_movies_notifier.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedMoviesNotifier provider;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider = TopRatedMoviesNotifier(getTopRatedMovies: mockGetTopRatedMovies)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('get top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchTopRatedMovies();
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        // act
        await provider.fetchTopRatedMovies();
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.movies, testMovieList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedMovies();
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
