import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });
  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<PopularMoviesBloc>.value(value: popularMoviesBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  group('Populars Movies Page', () {
    testWidgets('Page should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      popularMoviesBloc.emit(PopularMoviesLoading());
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right([]));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(createTestableWidget(PopularMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (
      WidgetTester tester,
    ) async {
      popularMoviesBloc.emit(PopularMoviesHasData([tMovie]));
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right([tMovie]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(createTestableWidget(PopularMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (
      WidgetTester tester,
    ) async {
      popularMoviesBloc.emit(PopularMoviesError('Error message'));
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Error message')));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(createTestableWidget(PopularMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });


  testWidgets('Page should display text No Data', (
    WidgetTester tester,
  ) async {
    popularMoviesBloc.emit(PopularMoviesEmpty());
    when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right([]));

    await tester.pumpWidget(createTestableWidget(PopularMoviesPage()));
    final textFinder = find.byKey(Key('empty_message'));
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(find.text('No Data'), findsOneWidget);
  });
}
