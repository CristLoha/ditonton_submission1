import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/domain/entities/movie.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_search_page.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_search_notifier.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieSearchNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
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

    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.searchResult).thenReturn([tMovie]);

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MediaCardList), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Page should display empty container when search is empty', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });
}
