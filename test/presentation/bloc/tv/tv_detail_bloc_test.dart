import 'package:bloc_test/bloc_test.dart';
import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:home/home.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetWatchListStatusTv mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetWatchlistStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  final testTvDetail = TvDetail(
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfSeasons: 1,
    numberOfEpisodes: 50,
    adult: false,
    backdropPath: '/h0y3OzHzG4yNvn8u3Za6ByH8lrQ.jpg',
    id: 45789,
    name: 'Sturm der Liebe',
    overview:
        'These are the stories of relationships taking place in the fictional five-star hotel Fürstenhof, located in Feldkirchen-Westerham near Rosenheim with the plot revolving around members of the family room area, the hotel owners, and employees.',
    posterPath: '/jfFNydakwvbeACEwSd2Gh8UWtba.jpg',
    voteAverage: 6.014,
    voteCount: 36,
    firstAirDate: DateTime.parse('2005-09-26'),
    genreIds: [18],
    originalName: 'Sturm der Liebe',
    originCountry: ['DE'],
    originalLanguage: 'de',
    popularity: 572.0316,
  );

  final testTv = Tv(
    id: 100088,
    name: 'The Last of Us',
    overview:
        'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
    posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
    voteAverage: 8.579,
    voteCount: 5750,
    adult: false,
    backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
    genreIds: [18],
    originalName: 'The Last of Us',
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 433.6105,
    firstAirDate: DateTime.parse('2023-01-15'),
  );

final testTvList = [testTv];
  const tId =  45789;

  group('Get Tv Show Detail', () {
    test('initial state should be empty', () {
      expect(tvDetailBloc.state, TvDetailEmpty());
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [loading, loaded, recommendation loading, recommendation loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        when(
          mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(tId)),
      expect:
          () => [
            TvDetailLoading(),
            TvDetailHasData(
              tv: testTvDetail,
              recommendations: testTvList,
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [loading, error] when get tv detail is unsuccessful',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right([testTv]));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [TvDetailLoading(), TvDetailError('Server Failure')],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [loading, loaded, recommendation loading, error] when get recommendation is unsuccessful',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect:
          () => [
            TvDetailLoading(),
            TvDetailHasData(
              tv: testTvDetail,
              recommendations: [],
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    group('Watchlist', () {
      blocTest<TvDetailBloc, TvDetailState>(
        'should emit [Loading, HasData, HasData with Added to Watchlist] when AddWatchlist is successful',
        build: () {
          when(
            mockGetTvDetail.execute(tId),
          ).thenAnswer((_) async => Right(testTvDetail));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => false);
          when(
            mockGetTvRecommendations.execute(tId),
          ).thenAnswer((_) async => Right(testTvList));
          when(
            mockSaveWatchlist.execute(testTvDetail),
          ).thenAnswer((_) async => Right('Added to Watchlist'));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => true);

          return tvDetailBloc;
        },
        act: (bloc) async {
          bloc.add(const FetchTvDetail(tId));
          await Future.delayed(Duration.zero);
          bloc.add(AddWatchlist(testTvDetail));
        },
        expect:
            () => [
              TvDetailLoading(),
              TvDetailHasData(
                tv: testTvDetail,
                recommendations: testTvList,
                isAddedToWatchlist: true,
              ),
              TvDetailHasData(
                tv: testTvDetail,
                recommendations: testTvList,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist',
              ),
            ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId)).called(1);
          verify(mockGetTvRecommendations.execute(tId)).called(1);
          verify(mockSaveWatchlist.execute(testTvDetail)).called(1);
          verify(
            mockGetWatchlistStatus.execute(tId),
          ).called(greaterThanOrEqualTo(1));
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit proper states when removing from watchlist is successful',
        build: () {
          when(
            mockGetTvDetail.execute(tId),
          ).thenAnswer((_) async => Right(testTvDetail));
          when(
            mockGetTvRecommendations.execute(tId),
          ).thenAnswer((_) async => Right([testTv]));
          when(
            mockRemoveWatchlist.execute(testTvDetail),
          ).thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => false);
          return tvDetailBloc;
        },
        act: (bloc) async {
          bloc.add(const FetchTvDetail(tId));
          await Future.delayed(Duration.zero);
          bloc.add(RemoveFromWatchlist(testTvDetail));
        },
        expect:
            () => [
              TvDetailLoading(),
              TvDetailHasData(
                tv: testTvDetail,
                recommendations: [testTv],
                isAddedToWatchlist: false,
              ),

              TvDetailHasData(
                tv: testTvDetail,
                recommendations: [testTv],
                isAddedToWatchlist: false,
                watchlistMessage: 'Removed from Watchlist',
              ),
            ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecommendations.execute(tId));
          verify(mockRemoveWatchlist.execute(testTvDetail));
          verify(mockGetWatchlistStatus.execute(tId));
        },
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit proper states when getting watchlist status',
        build: () {
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => true);
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
        expect: () => [TvDetailLoading()],
        verify: (_) {
          verify(mockGetWatchlistStatus.execute(tId));
        },
      );
    });
  });
}
