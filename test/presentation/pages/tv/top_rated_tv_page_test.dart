import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [BlocProvider<TopRatedTvBloc>.value(value: topRatedTvBloc)],
      child: MaterialApp(home: body),
    );
  }

  final tTv = Tv(
    adult: false,
    backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
    genreIds: [18],
    id: 100088,
    originalName: 'The Last of Us',
    overview: 'Twenty years after modern civilization has been destroyed...',
    popularity: 433.6105,
    posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
    firstAirDate: DateTime.parse('2023-01-15'),
    name: 'The Last of Us',
    voteAverage: 8.579,
    voteCount: 5750,
    originCountry: ['US'],
    originalLanguage: 'en',
  );

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    topRatedTvBloc.emit(TopRatedTvLoading());
    when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([]));
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(createTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    topRatedTvBloc.emit(TopRatedTvHasData([tTv]));
    when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([tTv]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(createTestableWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    topRatedTvBloc.emit(TopRatedTvError('Error message'));
    when(
      mockGetTopRatedTv.execute(),
    ).thenAnswer((_) async => Left(ServerFailure('Error message')));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(createTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text No Data', (WidgetTester tester) async {
    topRatedTvBloc.emit(TopRatedTvEmpty());
    when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right([]));

    await tester.pumpWidget(createTestableWidget(TopRatedTvPage()));
    final textFinder = find.byKey(Key('empty_message'));
    final centerFinder = find.byType(Center);

    await tester.pump();

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(find.text('No Data'), findsOneWidget);
  });
}
