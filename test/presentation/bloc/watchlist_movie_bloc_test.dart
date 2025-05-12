import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: '2020-01-01',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  group('Get Watchlist Movies', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect:
          () => [WatchlistMovieLoading(), WatchlistMovieHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMoviesEvent()),
      expect:
          () => [
            WatchlistMovieLoading(),
            WatchlistMovieError('Server Failure'),
          ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
