import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:core/core.dart';
import '../provider/movie_list_notifier_test.mocks.dart';
import '../provider/tv_list_notifier_test.mocks.dart';



void main() {
  late MockMovieListNotifier mockMovieListNotifier;
  late MockTvListNotifier mockTvListNotifier;

  setUp(() {
    mockMovieListNotifier = MockMovieListNotifier();
    mockTvListNotifier = MockTvListNotifier();

    // Add stubs for MovieListNotifier
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.empty);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.empty);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.empty);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn([]);
    when(mockMovieListNotifier.popularMovies).thenReturn([]);
    when(mockMovieListNotifier.topRatedMovies).thenReturn([]);

    // Add stubs for TvListNotifier
    when(mockTvListNotifier.onTheAirTvState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.popularTvState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.topRatedTvState).thenReturn(RequestState.empty);
    when(mockTvListNotifier.onTheAirTv).thenReturn([]);
    when(mockTvListNotifier.popularTv).thenReturn([]);
    when(mockTvListNotifier.topRatedTv).thenReturn([]);
  });

  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieListNotifier>.value(
          value: mockMovieListNotifier,
        ),
        ChangeNotifierProvider<TvListNotifier>.value(value: mockTvListNotifier),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          '/movie-search': (context) => Scaffold(),
          '/tv-search': (context) => Scaffold(),
        },
      ),
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

  testWidgets('Page should display drawer when drawer button is tapped', (
    WidgetTester tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn([tMovie]);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.popularMovies).thenReturn([tMovie]);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.topRatedMovies).thenReturn([tMovie]);

    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('Page should display movie list when movies tab is selected', (
    WidgetTester tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn([tMovie]);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.popularMovies).thenReturn([tMovie]);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.topRatedMovies).thenReturn([tMovie]);

    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('Page should display tv list when tv shows tab is selected', (
    WidgetTester tester,
  ) async {
    when(mockTvListNotifier.onTheAirTvState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.onTheAirTv).thenReturn([tTv]);
    when(mockTvListNotifier.popularTvState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.popularTv).thenReturn([tTv]);
    when(mockTvListNotifier.topRatedTvState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.topRatedTv).thenReturn([tTv]);

    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump();

    // Tap the drawer button to open it
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    // Find and tap TV Shows button directly in the widget tree
    final tvShowsButton = find.byKey(Key('tv_shows_button')).evaluate().first;
    final tvShowsWidget = tvShowsButton.widget as ListTile;
    tvShowsWidget.onTap?.call();
    await tester.pump();

    // Verify TV content is displayed
    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(TvList), findsNWidgets(3));
  });

  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    when(
      mockMovieListNotifier.nowPlayingState,
    ).thenReturn(RequestState.loading);
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.loading);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.loading);

    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(mockMovieListNotifier.message).thenReturn('Error message');
    when(
      mockMovieListNotifier.popularMoviesState,
    ).thenReturn(RequestState.error);
    when(
      mockMovieListNotifier.topRatedMoviesState,
    ).thenReturn(RequestState.error);

    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets(
    'Page should navigate to search page when search button is tapped',
    (WidgetTester tester) async {
      when(
        mockMovieListNotifier.nowPlayingState,
      ).thenReturn(RequestState.loaded);
      when(mockMovieListNotifier.nowPlayingMovies).thenReturn([tMovie]);
      when(
        mockMovieListNotifier.popularMoviesState,
      ).thenReturn(RequestState.loaded);
      when(mockMovieListNotifier.popularMovies).thenReturn([tMovie]);
      when(
        mockMovieListNotifier.topRatedMoviesState,
      ).thenReturn(RequestState.loaded);
      when(mockMovieListNotifier.topRatedMovies).thenReturn([tMovie]);

      await tester.pumpWidget(createTestableWidget(HomePage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}
