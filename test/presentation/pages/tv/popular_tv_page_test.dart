import 'package:core/core.dart';
import 'package:ditonton_submission1/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ditonton_submission1/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_detail_notifier.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockPopularTvNotifier mockNotifier;
  late MockTvDetailNotifier mockTvDetailNotifier;

  setUp(() {
    mockNotifier = MockPopularTvNotifier();
    mockTvDetailNotifier = MockTvDetailNotifier();
  });

  Widget createTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PopularTvNotifier>.value(value: mockNotifier),
          ChangeNotifierProvider<TvDetailNotifier>.value(
            value: mockTvDetailNotifier,
          ),
        ],
        child: body,
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/tv-detail':
            final id = settings.arguments as int;
            return MaterialPageRoute(
              builder:
                  (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<TvDetailNotifier>.value(
                        value: mockTvDetailNotifier,
                      ),
                    ],
                    child: Scaffold(body: Text('TV Detail Page - ID: $id')),
                  ),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) {
                return const Scaffold(body: Text('Default Page'));
              },
            );
        }
      },
    );
  }

  final testTvList = [
    Tv(
      id: 1,
      name: 'Test TV Show 1',
      overview: 'Test Overview 1',
      posterPath: '/test1.jpg',
      voteAverage: 8.5,
      voteCount: 100,
      firstAirDate: DateTime.parse('2023-01-01'),
      genreIds: [1, 2],
      adult: false,
      backdropPath: '/test1.jpg',
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'Test TV Show 1',
      popularity: 100.0,
    ),
    Tv(
      id: 2,
      name: 'Test TV Show 2',
      overview: 'Test Overview 2',
      posterPath: '/test2.jpg',
      voteAverage: 9.0,
      voteCount: 200,
      firstAirDate: DateTime.parse('2023-02-01'),
      genreIds: [3, 4],
      adult: false,
      backdropPath: '/test2.jpg',
      originCountry: ['UK'],
      originalLanguage: 'en',
      originalName: 'Test TV Show 2',
      popularity: 200.0,
    ),
  ];

  testWidgets('Page should display tv data when loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvList);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.text('Test TV Show 1'), findsOneWidget);
    expect(find.text('Test Overview 1'), findsOneWidget);
    expect(find.text('Test TV Show 2'), findsOneWidget);
    expect(find.text('Test Overview 2'), findsOneWidget);
  });

  testWidgets('Page should display loading indicator when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.text('Error message'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Page should navigate to detail page when tv is tapped', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvList);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    await tester.pump();

    // Find and tap the first TV show
    final firstTvCard = find.byType(MediaCardList).first;
    await tester.tap(firstTvCard);
    await tester.pumpAndSettle();

    // Verify navigation with correct ID
    expect(find.text('TV Detail Page - ID: 1'), findsOneWidget);
  });

  testWidgets('Page should display correct app bar title', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn([]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.text('Popular TV Shows'), findsOneWidget);
  });

  testWidgets('Page should display empty message when no data', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn([]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.text('No TV shows found'), findsOneWidget);
  });

  testWidgets('Page should display retry button when error occurs', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockNotifier.fetchPopularTv()).called(2);
  });

  testWidgets('Page should display correct number of TV shows', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvList);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    await tester.pump();

    expect(find.byType(MediaCardList), findsNWidgets(2));
  });

  testWidgets('Page should display correct TV show details', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvList);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    expect(find.text('Test TV Show 1'), findsOneWidget);
    expect(find.text('Test Overview 1'), findsOneWidget);
    expect(find.text('Test TV Show 2'), findsOneWidget);
    expect(find.text('Test Overview 2'), findsOneWidget);
  });

  testWidgets('Page should handle empty state correctly', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);
    when(mockNotifier.tv).thenReturn([]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('Should return Container when state is empty', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);
    when(mockNotifier.tv).thenReturn([]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));

    final containerFinder = find.byType(Container);
    expect(containerFinder, findsOneWidget);
  });

  testWidgets('Should navigate to TV Detail Page when TV card is tapped', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn([testTvList.first]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    await tester.pump();

    final tvCardFinder = find.byType(MediaCardList);
    expect(tvCardFinder, findsOneWidget);

    await tester.tap(tvCardFinder);
    await tester.pumpAndSettle();

    expect(
      find.text('TV Detail Page - ID: ${testTvList.first.id}'),
      findsOneWidget,
    );
  });

  testWidgets('Should use correct route name for navigation', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn([testTvList.first]);

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    await tester.pump();

    final tvCardFinder = find.byType(MediaCardList);
    await tester.tap(tvCardFinder);
    await tester.pumpAndSettle();

    expect(
      find.text('TV Detail Page - ID: ${testTvList.first.id}'),
      findsOneWidget,
    );
  });
}
