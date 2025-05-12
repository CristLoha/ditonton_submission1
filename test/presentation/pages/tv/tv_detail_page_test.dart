// import 'package:core/core.dart';
// import 'package:ditonton_submission1/features/tv/presentation/pages/tv_detail_page.dart';
// import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_detail_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import '../../../dummy_data/dummy_objects.dart';
// import '../../../helpers/test_helper.mocks.dart';

// void main() {
//   late MockTvDetailNotifier mockNotifier;

//   setUp(() {
//     mockNotifier = MockTvDetailNotifier();
//   });

//   Widget makeTestableWidget(Widget body) {
//     return ChangeNotifierProvider<TvDetailNotifier>.value(
//       value: mockNotifier,
//       child: MaterialApp(home: body),
//     );
//   }

//   testWidgets(
//     'Watchlist button should display add icon when tv not added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.tvRecommendations).thenReturn([testTv]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//       final watchlistButtonIcon = find.byIcon(Icons.add);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//       expect(watchlistButtonIcon, findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display check icon when tv is added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.tvRecommendations).thenReturn([testTv]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(true);

//       final watchlistButtonIcon = find.byIcon(Icons.check);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//       expect(watchlistButtonIcon, findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display Snackbar when added to watchlist',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.tvRecommendations).thenReturn([testTv]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
//       when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

//       final watchlistButton = find.byType(FilledButton);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//       expect(find.byIcon(Icons.add), findsOneWidget);

//       await tester.tap(watchlistButton);
//       await tester.pump();

//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Added to Watchlist'), findsOneWidget);
//     },
//   );

//   testWidgets(
//     'Watchlist button should display Snackbar with error message when add to watchlist failed',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
//       when(mockNotifier.tvRecommendations).thenReturn([testTv]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);
//       when(mockNotifier.watchlistMessage).thenReturn('Failed');

//       final watchlistButton = find.byType(FilledButton);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//       expect(find.byIcon(Icons.add), findsOneWidget);

//       await tester.tap(watchlistButton);
//       await tester.pump();

//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Failed'), findsOneWidget);
//     },
//   );

//   testWidgets('Should display loading indicator when tv detail is loading', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.state).thenReturn(RequestState.loading);

//     await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//     expect(find.byType(CircularProgressIndicator), findsOneWidget);
//   });

//   testWidgets('Should display error message when tv detail failed to load', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.state).thenReturn(RequestState.error);
//     when(mockNotifier.message).thenReturn('Error message');

//     await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//     expect(find.text('Error message'), findsOneWidget);
//   });

//   testWidgets(
//     'Should display recommendation loading indicator when recommendation is loading',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
//       when(mockNotifier.tvRecommendations).thenReturn([]);
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

//       expect(find.byType(CircularProgressIndicator), findsWidgets);
//     },
//   );

//   testWidgets(
//     'Should display recommendation error message when recommendation failed to load',
//     (WidgetTester tester) async {
//       when(mockNotifier.state).thenReturn(RequestState.loaded);
//       when(mockNotifier.tv).thenReturn(testTvDetail);
//       when(mockNotifier.recommendationState).thenReturn(RequestState.error);
//       when(mockNotifier.tvRecommendations).thenReturn([]);
//       when(mockNotifier.message).thenReturn('Error message');
//       when(mockNotifier.isAddedToWatchlist).thenReturn(false);

//       await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));
//       await tester.pump();

//       expect(find.text('Error message'), findsOneWidget);
//     },
//   );
// }
