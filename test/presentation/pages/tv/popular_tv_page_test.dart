import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });
  Widget createTestableWidget(Widget body) {
    return MultiProvider(
      providers: [BlocProvider<PopularTvBloc>.value(value: popularTvBloc)],
      child: MaterialApp(home: body),
    );
  }

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

  group('Populars Tv Page', () {
    testWidgets('Page should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      popularTvBloc.emit(PopularTvLoading());
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([]));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(createTestableWidget(PopularTvPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (
      WidgetTester tester,
    ) async {
      popularTvBloc.emit(PopularTvHasData([tTv]));
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([tTv]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(createTestableWidget(PopularTvPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (
      WidgetTester tester,
    ) async {
      popularTvBloc.emit(PopularTvError('Error message'));
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Error message')));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(createTestableWidget(PopularTvPage()));

      expect(textFinder, findsOneWidget);
    });
  });

  testWidgets('Page should display text No TV shows found', (
    WidgetTester tester,
  ) async {
    popularTvBloc.emit(PopularTvEmpty());
    when(mockGetPopularTv.execute()).thenAnswer((_) async => Right([]));

    await tester.pumpWidget(createTestableWidget(PopularTvPage()));
    final textFinder = find.byKey(Key('empty_message'));
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(find.text('No TV shows found'), findsOneWidget);
  });
}
