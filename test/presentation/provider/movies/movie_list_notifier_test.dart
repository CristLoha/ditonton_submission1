import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_list_notifier.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieListNotifier provider;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider = MovieListNotifier(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('now playing movies', () {
    test('initialState should be empty', () {
      expect(provider.nowPlayingState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchNowPlayingMovies();
      // assert
      verify(mockGetNowPlayingMovies.execute());
    });

    test('should change state to loading when usecase is called', () {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      await provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.loaded);
      expect(provider.nowPlayingMovies, testMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingMovies();
      // assert
      expect(provider.nowPlayingState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchPopularMovies();
      // assert
      expect(provider.popularMoviesState, RequestState.loading);
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
        expect(provider.popularMoviesState, RequestState.loaded);
        expect(provider.popularMovies, testMovieList);
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
      expect(provider.popularMoviesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchTopRatedMovies();
      // assert
      expect(provider.topRatedMoviesState, RequestState.loading);
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
        expect(provider.topRatedMoviesState, RequestState.loaded);
        expect(provider.topRatedMovies, testMovieList);
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
      expect(provider.topRatedMoviesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
