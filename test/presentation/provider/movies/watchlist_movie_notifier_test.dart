import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';


void main() {
  late WatchlistMovieNotifier provider;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    provider = WatchlistMovieNotifier(
      getWatchlistMovies: mockGetWatchlistMovies,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('get watchlist movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      // act
      provider.fetchWatchlistMovies();
      // assert
      expect(provider.watchlistState, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        // act
        await provider.fetchWatchlistMovies();
        // assert
        expect(provider.watchlistState, RequestState.loaded);
        expect(provider.watchlistMovies, testMovieList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await provider.fetchWatchlistMovies();
      // assert
      expect(provider.watchlistState, RequestState.error);
      expect(provider.message, "Can't get data");
      expect(listenerCallCount, 2);
    });
  });
}
