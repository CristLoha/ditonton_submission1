import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:home/presentation/bloc/home/home_cubit.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_state.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../bloc/movie_list_bloc_test.mocks.dart';
import '../bloc/tv_list_bloc_test.mocks.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  late MovieListBloc movieListBloc;
  late TvListBloc tvListBloc;
  late HomeCubit homeCubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    homeCubit = HomeCubit();
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
    when(
      mockGetPopularMovies.execute(),
    ).thenAnswer((_) async => const Left(ServerFailure('Error message')));
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
        BlocProvider<HomeCubit>.value(value: homeCubit),
        BlocProvider<MovieListBloc>.value(value: movieListBloc),
        BlocProvider<TvListBloc>.value(value: tvListBloc),
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

  testWidgets('Page should display drawer when drawer button is tapped', (
    WidgetTester tester,
  ) async {
    movieListBloc.emit(
      MovieListHasData(
        nowPlayingMovies: [tMovie],
        popularMovies: [tMovie],
        topRatedMovies: [tMovie],
      ),
    );

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
    await mockNetworkImagesFor(() async {
      movieListBloc.emit(
        MovieListHasData(
          nowPlayingMovies: [tMovie],
          popularMovies: [tMovie],
          topRatedMovies: [tMovie],
        ),
      );

      await tester.pumpWidget(createTestableWidget(HomePage()));
      await tester.pump();
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.byType(MovieList), findsNWidgets(3));
    });
  });
  testWidgets('Page should display tv list when tv shows tab is selected', (
    WidgetTester tester,
  ) async {
    homeCubit.toggleTab(false);
    tvListBloc.emit(
      TvListHasData(onTheAirTv: [tTv], popularTv: [tTv], topRatedTv: [tTv]),
    );

    await tester.pumpWidget(createTestableWidget(HomePage()));

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(TvList), findsNWidgets(3));

    verify(mockGetOnTheAirTv.execute()).called(1);
    verify(mockGetPopularTv.execute()).called(1);
    verify(mockGetTopRatedTv.execute()).called(1);
  });
  testWidgets('Page should display loading indicator when state is loading', (
    WidgetTester tester,
  ) async {
    movieListBloc.emit(MovieListLoading());
    await tester.pumpWidget(createTestableWidget(HomePage()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when state is error', (
    WidgetTester tester,
  ) async {
    movieListBloc.emit(MovieListError('Error Message'));
    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(createTestableWidget(HomePage()));
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Page should navigate to search page when search button is tapped',
    (WidgetTester tester) async {
      movieListBloc.emit(
        MovieListHasData(
          nowPlayingMovies: [tMovie],
          popularMovies: [tMovie],
          topRatedMovies: [tMovie],
        ),
      );
      await tester.pumpWidget(createTestableWidget(HomePage()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}
