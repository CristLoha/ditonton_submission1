import 'package:bloc_test/bloc_test.dart';
import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:home/home.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetWatchListStatusMovie mockGetWatchlistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    runtime: 120,
    title: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 1,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testMovieList = [testMovie];

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetWatchlistStatus = MockGetWatchListStatusMovie();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  const tId = 1;

  group('Get Movie Detail', () {
    test('initial state should be empty', () {
      expect(movieDetailBloc.state, MovieDetailEmpty());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [loading, loaded, recommendation loading, recommendation loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect:
          () => [
            MovieDetailLoading(),
            MovieDetailHasData(
              movie: testMovieDetail,
              recommendations: testMovieList,
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [loading, error] when get movie detail is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right([testMovie]));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Server Failure')],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [loading, loaded, recommendation loading, error] when get recommendation is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            MovieDetailLoading(),
            MovieDetailHasData(
              movie: testMovieDetail,
              recommendations: [],
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    group('Watchlist', () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'should emit [Loading, HasData, HasData with Added to Watchlist] when AddWatchlist is successful',
        build: () {
          when(
            mockGetMovieDetail.execute(tId),
          ).thenAnswer((_) async => Right(testMovieDetail));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => false);
          when(
            mockGetMovieRecommendations.execute(tId),
          ).thenAnswer((_) async => Right(testMovieList));
          when(
            mockSaveWatchlist.execute(testMovieDetail),
          ).thenAnswer((_) async => Right('Added to Watchlist'));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => true);

          return movieDetailBloc;
        },
        act: (bloc) async {
          bloc.add(const FetchMovieDetail(tId));
          await Future.delayed(Duration.zero);
          bloc.add(AddWatchlist(testMovieDetail));
        },
        expect:
            () => [
              MovieDetailLoading(),
              MovieDetailHasData(
                movie: testMovieDetail,
                recommendations: testMovieList,
                isAddedToWatchlist: true,
              ),
              MovieDetailHasData(
                movie: testMovieDetail,
                recommendations: testMovieList,
                isAddedToWatchlist: true,
                watchlistMessage: 'Added to Watchlist',
              ),
            ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId)).called(1);
          verify(mockGetMovieRecommendations.execute(tId)).called(1);
          verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
          verify(
            mockGetWatchlistStatus.execute(tId),
          ).called(greaterThanOrEqualTo(1));
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit proper states when removing from watchlist is successful',
        build: () {
          when(
            mockGetMovieDetail.execute(tId),
          ).thenAnswer((_) async => Right(testMovieDetail));
          when(
            mockGetMovieRecommendations.execute(tId),
          ).thenAnswer((_) async => Right([testMovie]));
          when(
            mockRemoveWatchlist.execute(testMovieDetail),
          ).thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => false);
          return movieDetailBloc;
        },
        act: (bloc) async {
          bloc.add(const FetchMovieDetail(tId));
          await Future.delayed(Duration.zero);
          bloc.add(RemoveFromWatchlist(testMovieDetail));
        },
        expect:
            () => [
              MovieDetailLoading(),
              MovieDetailHasData(
                movie: testMovieDetail,
                recommendations: [testMovie],
                isAddedToWatchlist: false,
              ),

              MovieDetailHasData(
                movie: testMovieDetail,
                recommendations: [testMovie],
                isAddedToWatchlist: false,
                watchlistMessage: 'Removed from Watchlist',
              ),
            ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetMovieRecommendations.execute(tId));
          verify(mockRemoveWatchlist.execute(testMovieDetail));
          verify(mockGetWatchlistStatus.execute(tId));
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit proper states when getting watchlist status',
        build: () {
          when(
            mockGetWatchlistStatus.execute(tId),
          ).thenAnswer((_) async => true);
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
        expect: () => [MovieDetailLoading()],
        verify: (_) {
          verify(mockGetWatchlistStatus.execute(tId));
        },
      );
    });
  });
}
