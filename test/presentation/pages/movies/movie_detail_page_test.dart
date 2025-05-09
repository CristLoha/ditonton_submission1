// import 'package:core/core.dart';
// import 'package:home/domain/entities/movie.dart';
// import 'package:ditonton_submission1/features/movies/presentation/pages/movie_detail_page.dart';
// import 'package:ditonton_submission1/features/movies/presentation/provider/movies/movie_detail_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../dummy_data/dummy_objects.dart';
// import '../../../helpers/test_helper.mocks.dart';

// void main() {
//   late MockMovieDetailNotifier mockNotifier;

//   setUp(() {
//     mockNotifier = MockMovieDetailNotifier();
//   });

//   Widget makeTestableWidget(Widget body) {
//     return ChangeNotifierProvider<MovieDetailNotifier>.value(
//       value: mockNotifier,
//       child: MaterialApp(home: body),
//     );
//   }

//   testWidgets(
//     'Watchlist button should display add icon when movie not added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movie).thenReturn(testMovieDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//       final watchlistButtonIcon = find.byIcon(Icons.add);

//       await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//       expect(watchlistButtonIcon, findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display check icon when movie is added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movie).thenReturn(testMovieDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(true);

//       final watchlistButtonIcon = find.byIcon(Icons.check);

//       await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//       expect(watchlistButtonIcon, findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display Snackbar when added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movie).thenReturn(testMovieDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
//       when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

//       final watchlistButton = find.byType(FilledButton);

//       await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//       expect(find.byIcon(Icons.add), findsOneWidget);

//       await tester.tap(watchlistButton);
//       await tester.pump();

//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Added to Watchlist'), findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display AlertDialog when add to watchlist failed',
//     (WidgetTester tester) async {
//       when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movie).thenReturn(testMovieDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
//       when(mockNotifier.watchlistMessage).thenReturn('Failed');

//       final watchlistButton = find.byType(FilledButton);

//       await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//       expect(find.byIcon(Icons.add), findsOneWidget);

//       await tester.tap(watchlistButton);
//       await tester.pump();

//       expect(find.byType(AlertDialog), findsOneWidget);
//       expect(find.text('Failed'), findsOneWidget);
//     },
//   );
//   testWidgets('Should show recommendation movies when available', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//     when(mockNotifier.movie).thenReturn(testMovieDetail);
//     when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//     when(mockNotifier.movieRecommendations).thenReturn([testMovie]);
//     when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//     await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//     await tester.drag(
//       find.byType(SingleChildScrollView).first,
//       const Offset(0, -300),
//     );
//     await tester.pump();

//     final recommendationText = find.text('Recommendations');
//     expect(recommendationText, findsOneWidget);

//     expect(find.byType(CachedNetworkImage), findsWidgets);
//   });

//   testWidgets('Should show loading indicator when recommendation is loading', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//     when(mockNotifier.movie).thenReturn(testMovieDetail);
//     when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
//     when(mockNotifier.movieRecommendations).thenReturn([]);
//     when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//     await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//     expect(find.byType(CircularProgressIndicator), findsWidgets);
//   });

//   testWidgets('Should show empty container on unknown recommendation state', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.movieState).thenReturn(RequestState.loaded);
//     when(mockNotifier.movie).thenReturn(testMovieDetail);
//     when(mockNotifier.recommendationState).thenReturn(RequestState.empty);
//     when(mockNotifier.movieRecommendations).thenReturn([]);
//     when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//     await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

//     // Container default tidak mudah ditemukan, tapi bisa dicek keberadaan parent
//     expect(find.byType(Container), findsWidgets);
//   });
// }
