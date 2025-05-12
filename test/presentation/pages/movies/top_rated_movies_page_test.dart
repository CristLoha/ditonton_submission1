import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<TopRatedMoviesBloc>.value(value: topRatedMoviesBloc),
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

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    topRatedMoviesBloc.emit(TopRatedMoviesLoading());
    when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right([]));
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(createTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    topRatedMoviesBloc.emit(TopRatedMoviesHasData([tMovie]));
    when(
      mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => Right([tMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(createTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    topRatedMoviesBloc.emit(TopRatedMoviesError('Error message'));
    when(mockGetTopRatedMovies.execute()).thenAnswer(
      (_) async => Left(ServerFailure('Error message')),
    );

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(createTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
