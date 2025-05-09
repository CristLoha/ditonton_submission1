import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/watchlist_page.dart';
import 'package:ditonton_submission1/features/movies/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/watchlist_tv_notifier.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWatchlistMovieNotifier mockMovieNotifier;
  late MockWatchlistTvNotifier mockTvNotifier;

  setUp(() {
    mockMovieNotifier = MockWatchlistMovieNotifier();
    mockTvNotifier = MockWatchlistTvNotifier();
  });

  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WatchlistMovieNotifier>.value(
          value: mockMovieNotifier,
        ),
        ChangeNotifierProvider<WatchlistTvNotifier>.value(
          value: mockTvNotifier,
        ),
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

  final tTv = Tv(
    adult: false,
    backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
    genreIds: [18],
    id: 100088,
    originalName: 'The Last of Us',
    overview:
        'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
    popularity: 433.6105,
    posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
    firstAirDate: DateTime.parse('2023-01-15'),
    name: 'The Last of Us',
    voteAverage: 8.579,
    voteCount: 5750,
    originCountry: ['US'],
    originalLanguage: 'en',
  );

  testWidgets('Page should display watchlist movies when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockMovieNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockMovieNotifier.watchlistMovies).thenReturn([tMovie]);

    await tester.pumpWidget(createTestableWidget(const WatchlistPage()));
    await tester.pump();

    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets(
    'Page should display watchlist tv shows when tv tab is selected',
    (WidgetTester tester) async {
      when(mockMovieNotifier.watchlistState).thenReturn(RequestState.loaded);
      when(mockMovieNotifier.watchlistMovies).thenReturn([]);
      when(mockTvNotifier.watchlistState).thenReturn(RequestState.loaded);
      when(mockTvNotifier.watchlistTv).thenReturn([tTv]);

      await tester.pumpWidget(createTestableWidget(const WatchlistPage()));
      await tester.pump();

      // Tap the TV Shows tab
      await tester.tap(find.text('TV Shows'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('The Last of Us'), findsOneWidget);
    },
  );

  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    when(mockMovieNotifier.watchlistState).thenReturn(RequestState.loading);
    when(mockTvNotifier.watchlistState).thenReturn(RequestState.loading);

    await tester.pumpWidget(createTestableWidget(const WatchlistPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    when(mockMovieNotifier.watchlistState).thenReturn(RequestState.error);
    when(mockMovieNotifier.message).thenReturn('Error message');
    when(mockTvNotifier.watchlistState).thenReturn(RequestState.error);
    when(mockTvNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(createTestableWidget(const WatchlistPage()));
    await tester.pump();

    expect(find.text('Error message'), findsOneWidget);

    // Tap the TV Shows tab
    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty message when watchlist is empty', (
    WidgetTester tester,
  ) async {
    when(mockMovieNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockMovieNotifier.watchlistMovies).thenReturn([]);
    when(mockTvNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockTvNotifier.watchlistTv).thenReturn([]);

    await tester.pumpWidget(createTestableWidget(const WatchlistPage()));
    await tester.pump();

    expect(find.text('No movies in watchlist'), findsOneWidget);

    // Tap the TV Shows tab
    await tester.tap(find.text('TV Shows'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('No TV shows in watchlist'), findsOneWidget);
  });
}
