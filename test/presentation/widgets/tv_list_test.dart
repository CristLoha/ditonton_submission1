import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/presentation/widgets/tv_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  Widget createTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testWidgets('TvList should display tv data correctly', (
    WidgetTester tester,
  ) async {
    final tvShows = [
      Tv(
        id: 1,
        name: 'Test TV Show',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.5,
        voteCount: 100,
        firstAirDate: DateTime.now(),
        genreIds: [1, 2],
        adult: false,
        backdropPath: '/test_backdrop.jpg',
        originCountry: ['US'],
        originalLanguage: 'en',
        originalName: 'Test Original Name',
        popularity: 100.0,
      ),
    ];

    await tester.pumpWidget(createTestableWidget(TvList(tvShows)));

    expect(find.text('Test TV Show'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('TvList should handle empty list', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TvList([])));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });
}
