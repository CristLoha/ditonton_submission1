import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
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
      expect(movieDetailBloc.state, const MovieDetailState());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [loading, loaded, recommendation loading, recommendation loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right([testMovie]));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.loading),
            MovieDetailState(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loading,
            ),
            MovieDetailState(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              movieRecommendations: [testMovie],
              recommendationState: RequestState.loaded,
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
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.loading),
            const MovieDetailState(
              movieState: RequestState.error,
              message: 'Server Failure',
            ),
          ],
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
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect:
          () => [
            const MovieDetailState(movieState: RequestState.loading),
            MovieDetailState(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loading,
            ),
            MovieDetailState(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should execute saving watchlist when function called',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(const FetchMovieDetail(tId));
        await Future.delayed(Duration.zero);
        bloc.add(const AddWatchlist());
      },
      expect:
          () => [
            // Initial loading state
            const MovieDetailState().copyWith(movieState: RequestState.loading),

            // Detail loaded, recommendation loading
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loading,
            ),

            // Recommendation loaded
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loaded,
              movieRecommendations: testMovieList,
            ),

            // Emit pesan "Added to Watchlist" tanpa mengubah isAddedToWatchlist
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loaded,
              movieRecommendations: testMovieList,
              message: 'Added to Watchlist',
            ),

            // Update isAddedToWatchlist menjadi true
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loaded,
              movieRecommendations: testMovieList,
              message: 'Added to Watchlist',
              isAddedToWatchlist: true,
            ),
          ],
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
        bloc.add(const RemoveFromWatchlist());
      },
      expect:
          () => [
            // Initial loading state
            const MovieDetailState().copyWith(movieState: RequestState.loading),

            // Detail loaded, recommendation loading
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loading,
            ),

            // Recommendation loaded
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loaded,
              movieRecommendations: [testMovie],
            ),

            // Emit pesan "Removed from Watchlist" dan update status
            const MovieDetailState().copyWith(
              movieState: RequestState.loaded,
              movie: testMovieDetail,
              recommendationState: RequestState.loaded,
              movieRecommendations: [testMovie],
              message: 'Removed from Watchlist',
              isAddedToWatchlist: false,
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
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: true)],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tId));
      },
    );
  });
}
