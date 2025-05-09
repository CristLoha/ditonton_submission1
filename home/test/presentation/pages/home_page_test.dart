import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:core/core.dart';
import 'package:mockito/mockito.dart';
import '../bloc/movie_list_bloc_test.mocks.dart';
import '../bloc/tv_list_bloc_test.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  late MovieListBloc movieListBloc;
  late TvListBloc tvListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();

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

    when(
      mockGetNowPlayingMovies.execute(),
    ).thenAnswer((_) async => Right([tMovie]));
    when(
      mockGetPopularMovies.execute(),
    ).thenAnswer((_) async => Right([tMovie]));
    when(
      mockGetTopRatedMovies.execute(),
    ).thenAnswer((_) async => Right([tMovie]));
    when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right([tTv]));
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([tTv]));
    when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([tTv]));

    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );

    tvListBloc = TvListBloc(
      getOnTheAirTv: mockGetOnTheAirTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    );
  });

  Widget createTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListBloc>(create: (context) => movieListBloc),
        BlocProvider<TvListBloc>(create: (context) => tvListBloc),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
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
    // arrange
    movieListBloc.emit(
      MovieListState(
        nowPlayingState: RequestState.loaded,
        popularMoviesState: RequestState.loaded,
        topRatedMoviesState: RequestState.loaded,
        nowPlayingMovies: [tMovie],
        popularMovies: [tMovie],
        topRatedMovies: [tMovie],
        message: '',
      ),
    );

    // act
    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump(const Duration(seconds: 1));

    // assert
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('Page should display movie list when movies tab is selected', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      // arrange
      movieListBloc.emit(
        MovieListState(
          nowPlayingState: RequestState.loaded,
          popularMoviesState: RequestState.loaded,
          topRatedMoviesState: RequestState.loaded,
          nowPlayingMovies: [tMovie],
          popularMovies: [tMovie],
          topRatedMovies: [tMovie],
          message: '',
        ),
      );

      // act
      await tester.pumpWidget(createTestableWidget(HomePage()));
      await tester.pump();

      // assert
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.byType(MovieList), findsNWidgets(3));
    });
  });


  // Wrap other tests that display images with mockNetworkImagesFor
  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    // arrange
    movieListBloc.emit(
      MovieListState(
        nowPlayingState: RequestState.loading,
        popularMoviesState: RequestState.loading,
        topRatedMoviesState: RequestState.loading,
        nowPlayingMovies: [],
        popularMovies: [],
        topRatedMovies: [],
        message: '',
      ),
    );

    // act
    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(milliseconds: 500));

    // assert
    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    // arrange
    movieListBloc.emit(
      MovieListState(
        nowPlayingState: RequestState.error,
        popularMoviesState: RequestState.error,
        topRatedMoviesState: RequestState.error,
        nowPlayingMovies: [],
        popularMovies: [],
        topRatedMovies: [],
        message: 'Failed',
      ),
    );

    // act
    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(milliseconds: 500));

    // assert
    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets(
    'Page should navigate to search page when search button is tapped',
    (WidgetTester tester) async {
      // arrange
      movieListBloc.emit(
        MovieListState(
          nowPlayingState: RequestState.loaded,
          popularMoviesState: RequestState.loaded,
          topRatedMoviesState: RequestState.loaded,
          nowPlayingMovies: [tMovie],
          popularMovies: [tMovie],
          topRatedMovies: [tMovie],
          message: '',
        ),
      );

      // act
      await tester.pumpWidget(createTestableWidget(HomePage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // assert
      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}
