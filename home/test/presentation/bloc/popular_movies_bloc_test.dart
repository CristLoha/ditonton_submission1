import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';


@GenerateMocks([
  GetPopularMovies,
])
void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
  });

  group('Popular Movies', () {
    test('initial state harus kosong', () {
      expect(bloc.state, const PopularMoviesState());
    });

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'harus emit [loading, loaded] ketika data popular berhasil diambil',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect: () => [
        const PopularMoviesState(state: RequestState.loading),
        PopularMoviesState(
          state: RequestState.loaded,
          movies: testMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'harus emit [loading, error] ketika gagal mengambil data popular',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMoviesData()),
      expect: () => [
        const PopularMoviesState(state: RequestState.loading),
        const PopularMoviesState(
          state: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}