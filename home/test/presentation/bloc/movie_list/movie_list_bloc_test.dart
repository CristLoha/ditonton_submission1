import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:core/core.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final testMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
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

  group('Now Playing Movies', () {
    test('initial state should be empty', () {
      expect(bloc.state, MovieListEmpty());
    });

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when now playing data is successfully fetched',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [
            MovieListLoading(),
            MovieListHasData(
              nowPlayingMovies: testMovieList,
              popularMovies: [],
              topRatedMovies: [],
            ),
          ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when now playing data is unsuccessfully fetched',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [MovieListLoading(), const MovieListError('Server Failure')],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, empty] when now playing data is empty',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [
            MovieListLoading(),
            const MovieListHasData(
              nowPlayingMovies: [],
              popularMovies: [],
              topRatedMovies: [],
            ),
          ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when getting now playing data has connection failure',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
          (_) async => Left(ConnectionFailure('Connection Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect:
          () => [
            MovieListLoading(),
            const MovieListError('Connection Failure'),
          ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('Popular Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when popular data is successfully fetched',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieListPopularMovies()),
      expect:
          () => [
            MovieListLoading(),
            MovieListHasData(
              popularMovies: testMovieList,
              nowPlayingMovies: [],
              topRatedMovies: [],
            ),
          ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when popular data is unsuccessfully fetched',

      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieListPopularMovies()),
      expect:
          () => [MovieListLoading(), const MovieListError('Server Failure')],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('Top Rated Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when top rated data is successfully fetched',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect:
          () => [
            MovieListLoading(),
            MovieListHasData(
              topRatedMovies: testMovieList,
              nowPlayingMovies: [],
              popularMovies: [],
            ),
          ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when top rated data is unsuccessfully fetched',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
          (_) async => Left(ConnectionFailure('Connection Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect:
          () => [
            MovieListLoading(),
            const MovieListError('Connection Failure'),
          ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });


}
