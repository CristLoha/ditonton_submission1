// import 'package:core/core.dart';
// import 'package:home/domain/entities/tv.dart';
// import 'package:ditonton_submission1/features/tv/presentation/pages/tv_search_page.dart';
// import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_search_notifier.dart';
// import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import '../../../helpers/test_helper.mocks.dart';

// void main() {
//   late MockTvSearchNotifier mockNotifier;

//   setUp(() {
//     mockNotifier = MockTvSearchNotifier();
//   });

//   Widget makeTestableWidget(Widget body) {
//     return ChangeNotifierProvider<TvSearchNotifier>.value(
//       value: mockNotifier,
//       child: MaterialApp(home: body),
//     );
//   }

//   testWidgets('Page should display center progress bar when loading', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.state).thenReturn(RequestState.loading);

//     await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
//     await tester.enterText(find.byType(TextField), 'The Last of Us');
//     await tester.pump();

//     expect(find.byType(CircularProgressIndicator), findsOneWidget);
//   });

//   testWidgets('Page should display ListView when data is loaded', (
//     WidgetTester tester,
//   ) async {
//     final tTv = Tv(
//       adult: false,
//       backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
//       genreIds: [18],
//       id: 100088,
//       originalName: 'The Last of Us',
//       overview: 'Twenty years after modern civilization has been destroyed...',
//       popularity: 433.6105,
//       posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
//       firstAirDate: DateTime.parse('2023-01-15'),
//       name: 'The Last of Us',
//       voteAverage: 8.579,
//       voteCount: 5750,
//       originCountry: ['US'],
//       originalLanguage: 'en',
//     );

//     when(mockNotifier.state).thenReturn(RequestState.loaded);
//     when(mockNotifier.searchResult).thenReturn([tTv]);

//     await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
//     await tester.enterText(find.byType(TextField), 'The Last of Us');
//     await tester.pump();

//     expect(find.byType(ListView), findsOneWidget);
//     expect(find.byType(MediaCardList), findsOneWidget);
//   });

//   testWidgets('Page should display text with message when Error', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.state).thenReturn(RequestState.error);
//     when(mockNotifier.message).thenReturn('Error message');

//     await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
//     await tester.enterText(find.byType(TextField), 'The Last of Us');
//     await tester.pump();

//     expect(find.byKey(const Key('error_message')), findsOneWidget);
//     expect(find.byType(ElevatedButton), findsOneWidget);
//   });

//   testWidgets('Page should display empty container when search is empty', (
//     WidgetTester tester,
//   ) async {
//     when(mockNotifier.state).thenReturn(RequestState.empty);

//     await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
//     await tester.enterText(find.byType(TextField), '');
//     await tester.pump();

//     expect(find.byType(Container), findsOneWidget);
//   });
// }
