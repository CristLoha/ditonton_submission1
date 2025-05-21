import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:core/core.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_event.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvListBloc bloc;
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    bloc = TvListBloc(
      getOnTheAirTv: mockGetOnTheAirTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    );
  });

  group('On The Air TV', () {
    test('initial state should be empty', () {
      expect(bloc.state, TvListEmpty());
    });

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when on the air data is successfully fetched',

      build: () {
        when(
          mockGetOnTheAirTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [TvListLoading(), TvListHasData(onTheAirTv: testTvList)],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when on the air data is unsuccessfully fetched',
      build: () {
        when(
          mockGetOnTheAirTv.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [TvListLoading(), const TvListError('Server Failure')],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, empty] when on the air data is empty',
      build: () {
        when(
          mockGetOnTheAirTv.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [TvListLoading(), const TvListHasData(onTheAirTv: [])],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when on the air data is unsuccessfully fetched',
      build: () {
        when(mockGetOnTheAirTv.execute()).thenAnswer(
          (_) async => Left(ConnectionFailure('Connection Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [TvListLoading(), const TvListError('Connection Failure')],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );
  });

  group('Popular TV', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when popular data is successfully fetched',
      build: () {
        when(
          mockGetPopularTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [TvListLoading(), TvListHasData(popularTv: testTvList)],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when popular data is unsuccessfully fetched',

      build: () {
        when(
          mockGetPopularTv.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [TvListLoading(), const TvListError('Server Failure')],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, empty] when popular data is empty',
      build: () {
        when(
          mockGetPopularTv.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [TvListLoading(), const TvListHasData(popularTv: [])],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when popular data is unsuccessfully fetched',
      build: () {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Left(ConnectionFailure('Connection Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [TvListLoading(), const TvListError('Connection Failure')],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );
  });

  group('Top Rated TV', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, loaded] when top rated data is successfully fetched',

      build: () {
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [TvListLoading(), TvListHasData(topRatedTv: testTvList)],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when top rated data is unsuccessfully fetched',

      build: () {
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [TvListLoading(), const TvListError('Server Failure')],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [loading, empty] when top rated data is empty',
      build: () {
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [TvListLoading(), const TvListHasData(topRatedTv: [])],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );
    blocTest<TvListBloc, TvListState>(
      'should emit [loading, error] when top rated data is unsuccessfully fetched',
      build: () {
        when(mockGetTopRatedTv.execute()).thenAnswer(
          (_) async => Left(ConnectionFailure('Connection Failure')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [TvListLoading(), const TvListError('Connection Failure')],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );
  });
}
