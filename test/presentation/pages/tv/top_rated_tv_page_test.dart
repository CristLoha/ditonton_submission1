import 'package:core/core.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTopRatedTvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTvNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final tTv = Tv(
      adult: false,
      backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
      genreIds: [18],
      id: 100088,
      originalName: 'The Last of Us',
      overview: 'Twenty years after modern civilization has been destroyed...',
      popularity: 433.6105,
      posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
      firstAirDate: DateTime.parse('2023-01-15'),
      name: 'The Last of Us',
      voteAverage: 8.579,
      voteCount: 5750,
      originCountry: ['US'],
      originalLanguage: 'en',
    );

    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn([tTv]);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('The Last of Us'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(makeTestableWidget(TopRatedTvPage()));
    await tester.pump();

    expect(find.text('Error message'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
