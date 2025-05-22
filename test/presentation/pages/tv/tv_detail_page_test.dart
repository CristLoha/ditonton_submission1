import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetWatchListStatusTv mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetWatchlistStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    mockGetTvRecommendations = MockGetTvRecommendations();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getTvRecommendations: mockGetTvRecommendations,
    );
  const tId = 45789;
    when(
      mockGetTvDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvDetail));
    when(
      mockGetTvRecommendations.execute(tId),
    ).thenAnswer((_) async => Right([testTv]));
    when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider.value(value: tvDetailBloc, child: body),
    );
  }
  const tId = 45789;

  testWidgets('Should show loading indicator when state is loading', (
    tester,
  ) async {
    tvDetailBloc.emit(TvDetailLoading());
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should show watchlist add icon when tv not added', (
    tester,
  ) async {
    tvDetailBloc.emit(
      TvDetailHasData(
        tv: testTvDetail,
        recommendations: [testTv],
        isAddedToWatchlist: false,
      ),
    );
    when(
      mockGetTvDetail.execute(1),
    ).thenAnswer((_) async => Right(testTvDetail));
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: tId)));
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Should show watchlist check icon when tv added', (
    tester,
  ) async {
    tvDetailBloc.emit(
      TvDetailHasData(
        tv: testTvDetail,
        recommendations: [testTv],
        isAddedToWatchlist: true,
      ),
    );
    when(
      mockGetTvDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvDetail));
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: tId)));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Should show recommendation movies when available', (
    tester,
  ) async {
    tvDetailBloc.emit(
      TvDetailHasData(
        tv: testTvDetail,
        recommendations: [testTv],
        isAddedToWatchlist: false,
      ),
    );
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: tId)));
    expect(find.text('Recommendation'), findsNothing);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('Should show loading indicator when recommendation is loading', (
    tester,
  ) async {
    tvDetailBloc.emit(TvDetailLoading());
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: tId)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should show empty container on unknown recommendation state', (
    tester,
  ) async {
    tvDetailBloc.emit(TvDetailError('Something went wrong'));
    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: tId)));
    expect(find.text('Something went wrong'), findsOneWidget);
  });
}
