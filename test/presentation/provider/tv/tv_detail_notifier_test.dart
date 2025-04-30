import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;
  late int listenerCallCount;
  final tId = 1;
  final testTv = <Tv>[tTv];

  void arrangeUsecase() {
    when(
      mockGetTvDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvDetail));
    when(
      mockGetTvRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(testTv));
  }

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('Tv Detail Notifier', () {
    group('Fetch Tv Detail', () {
      test('should get data from the usecase', () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchTvDetail(tId);
        // assert
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      });

      test('should change state to loading when usecase is called', () {
        // arrange
        arrangeUsecase();
        // act
        provider.fetchTvDetail(tId);
        // assert
        expect(provider.state, RequestState.loading);
        expect(listenerCallCount, 1);
      });

      test('should change tv data when data is gotten successfully', () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchTvDetail(tId);
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.tv, testTvDetail);
        expect(listenerCallCount, 3);
      });

      test(
        'should change recommendation tv when data is gotten successfully',
        () async {
          // arrange
          arrangeUsecase();
          // act
          await provider.fetchTvDetail(tId);
          // assert
          expect(provider.state, RequestState.loaded);
          expect(provider.tvRecommendations, testTv);
        },
      );
    });

    group('Movie Recommendations', () {
      test('should get data from the usecase', () async {
        // arrange
        arrangeUsecase();
        // act
        await provider.fetchTvDetail(tId);
        // assert
        verify(mockGetTvRecommendations.execute(tId));
        expect(provider.tvRecommendations, testTv);
      });

      test(
        'should update recommendation state when data is gotten successfully',
        () async {
          // arrange
          arrangeUsecase();
          // act
          await provider.fetchTvDetail(tId);
          // assert
          expect(provider.recommendationState, RequestState.loaded);
          expect(provider.tvRecommendations, testTv);
        },
      );

      test('should update error message when request in successful', () async {
        // arrange
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Failed')));
        // act
        await provider.fetchTvDetail(tId);
        // assert
        expect(provider.recommendationState, RequestState.error);
        expect(provider.message, 'Failed');
      });
    });

    group('Watchlist', () {
      test('should get the watchlist status', () async {
        // arrange
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        // act
        await provider.loadWatchlistStatus(tId);
        // assert
        expect(provider.isAddedToWatchlist, true);
      });
      test('should execute save watchlist when function called', () async {
        // arrange
        when(
          mockSaveWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => Right('Success'));
        when(
          mockGetWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => true);
        // act
        await provider.addWatchlist(testTvDetail);
        // assert
        verify(mockSaveWatchlist.execute(testTvDetail));
      });

      test('should execute remove watchlist when function called', () async {
        // arrange
        when(
          mockRemoveWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => Right('Removed'));
        when(
          mockGetWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => false);
        // act
        await provider.removeFromWatchlist(testTvDetail);
        // assert
        verify(mockRemoveWatchlist.execute(testTvDetail));
      });

         test(
        'should update watchlist status when add watchlist success',
        () async {
          // arrange
          when(
            mockSaveWatchlist.execute(testTvDetail),
          ).thenAnswer((_) async => Right('Added to Watchlist'));
          when(
            mockGetWatchListStatus.execute(testTvDetail.id),
          ).thenAnswer((_) async => true);
          // act
          await provider.addWatchlist(testTvDetail);
          // assert
          verify(mockGetWatchListStatus.execute(testTvDetail.id));
          expect(provider.isAddedToWatchlist, true);
          expect(provider.watchlistMessage, 'Added to Watchlist');
          expect(listenerCallCount, 2);
        },
      );

      test(
        'should update watchlist message when add watchlist failed',
        () async {
          // arrange
          when(
            mockSaveWatchlist.execute(testTvDetail),
          ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          when(
            mockGetWatchListStatus.execute(testTvDetail.id),
          ).thenAnswer((_) async => false);
          // act
          await provider.addWatchlist(testTvDetail);
          // assert
          expect(provider.watchlistMessage, 'Failed');
          expect(listenerCallCount, 2);
        },
      );
    });
     group('Error Handling', () {
      test('should return error when data is unsuccessful', () async {
        // arrange
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTv));
        // act
        await provider.fetchTvDetail(tId);
        // assert
        expect(provider.state, RequestState.error);
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    });
  });
}
