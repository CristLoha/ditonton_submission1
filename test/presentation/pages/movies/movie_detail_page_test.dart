import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_state.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchListStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusMovie();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();

    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
    when(
      mockGetMovieDetail.execute(1),
    ).thenAnswer((_) async => Right(testMovieDetail));
    when(
      mockGetMovieRecommendations.execute(1),
    ).thenAnswer((_) async => Right([testMovie]));
    when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider.value(value: movieDetailBloc, child: body),
    );
  }

  testWidgets('Should show loading indicator when state is loading', (
    tester,
  ) async {
    movieDetailBloc.emit(MovieDetailLoading());
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should show watchlist add icon when movie not added', (
    tester,
  ) async {
    movieDetailBloc.emit(
      MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ),
    );
    when(
      mockGetMovieDetail.execute(1),
    ).thenAnswer((_) async => Right(testMovieDetail));
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Should show watchlist check icon when movie added', (
    tester,
  ) async {
    movieDetailBloc.emit(
      MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: true,
      ),
    );
    when(
      mockGetMovieDetail.execute(1),
    ).thenAnswer((_) async => Right(testMovieDetail));
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Should show recommendation movies when available', (
    tester,
  ) async {
    movieDetailBloc.emit(
      MovieDetailHasData(
        movie: testMovieDetail,
        recommendations: [testMovie],
        isAddedToWatchlist: false,
      ),
    );
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.text('Recommendation'), findsNothing);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('Should show loading indicator when recommendation is loading', (
    tester,
  ) async {
    movieDetailBloc.emit(MovieDetailLoading());
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should show empty container on unknown recommendation state', (
    tester,
  ) async {
    movieDetailBloc.emit(MovieDetailError('Something went wrong'));
    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('Should show empty container on initial state', (tester) async {
    movieDetailBloc.emit(MovieDetailEmpty());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(DetailContent), findsNothing);
  });

  testWidgets('Should call initState and load initial data', (tester) async {
    // Setup initial responses
    when(
      mockGetMovieDetail.execute(1),
    ).thenAnswer((_) async => Right(testMovieDetail));
    when(
      mockGetMovieRecommendations.execute(1),
    ).thenAnswer((_) async => Right([testMovie]));
    when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);

    // Pump widget to trigger initState
    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pumpAndSettle();

    // Verify initial events were dispatched
    verify(mockGetMovieDetail.execute(1)).called(1);
    verify(mockGetWatchListStatus.execute(1)).called(1);
  });
}
