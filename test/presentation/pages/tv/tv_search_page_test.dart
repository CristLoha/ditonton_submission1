import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchTvBloc>.value(
      value: searchTvBloc,
      child: MaterialApp(home: body),
    );
  }

  test('initial state should be empty', () {
    expect(searchTvBloc.state, SearchTvEmpty());
  });


  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    searchTvBloc.emit(SearchTvLoading());

    await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
    await tester.enterText(find.byType(TextField), 'The Last of Us');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    searchTvBloc.emit(SearchTvHasData([tTv]));

    await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
    await tester.enterText(find.byType(TextField), 'The Last of Us');
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MediaCardList), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    searchTvBloc.emit(SearchTvError('Error message'));

    await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
    await tester.enterText(find.byType(TextField), 'The Last of Us');
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Page should display empty container when search is empty', (
    WidgetTester tester,
  ) async {
    searchTvBloc.emit(SearchTvEmpty());

    await tester.pumpWidget(makeTestableWidget(TvSearchPage()));
    await tester.enterText(find.byType(TextField), 'The Last of Us');
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });
}
