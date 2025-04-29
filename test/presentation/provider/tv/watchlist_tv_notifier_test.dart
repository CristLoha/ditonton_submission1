import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistTvNotifier provider;
  late MockGetWatchListTv mockGetWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTv = MockGetWatchListTv();
    provider = WatchlistTvNotifier(getWatchlistTv: mockGetWatchlistTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('get watchlist tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchWatchlistTv();
      // assert
      expect(provider.watchlistState, RequestState.loading);
    });

    test(
      'should change state to loaded when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetWatchlistTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        // act
        await provider.fetchWatchlistTv();
        // assert
        expect(provider.watchlistState, RequestState.loaded);
        expect(provider.watchlistTv, testTvList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await provider.fetchWatchlistTv();
      // assert
      expect(provider.watchlistState, RequestState.error);
      expect(provider.message, "Can't get data");
      expect(listenerCallCount, 2);
    });
  });
}
