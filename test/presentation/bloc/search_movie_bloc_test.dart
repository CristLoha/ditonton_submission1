import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchMovieBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchMovieBloc(mockSearchMovies);
  });
  final testMovieModel = Movie(
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

  final testMovieList = <Movie>[testMovieModel];

  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  group('SearchMovieBloc', () {
    blocTest<SearchMovieBloc, SearchMovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(testMovieList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SearchLoading(), SearchHasData(testMovieList)],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });
}
