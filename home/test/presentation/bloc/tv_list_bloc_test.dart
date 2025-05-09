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


@GenerateMocks([
  GetOnTheAirTv,
  GetPopularTv,
  GetTopRatedTv,
])
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
    test('initial state harus kosong', () {
      expect(bloc.state, const TvListState());
    });

    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, loaded] ketika data berhasil diambil',
      build: () {
        when(mockGetOnTheAirTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [
        const TvListState(onTheAirTvState: RequestState.loading),
        TvListState(
          onTheAirTvState: RequestState.loaded,
          onTheAirTv: testTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, error] ketika gagal mengambil data',
      build: () {
        when(mockGetOnTheAirTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTv()),
      expect: () => [
        const TvListState(onTheAirTvState: RequestState.loading),
        const TvListState(
          onTheAirTvState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTv.execute());
      },
    );
  });

  group('Popular TV', () {
    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, loaded] ketika data popular berhasil diambil',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        const TvListState(popularTvState: RequestState.loading),
        TvListState(
          popularTvState: RequestState.loaded,
          popularTv: testTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, error] ketika gagal mengambil data popular',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        const TvListState(popularTvState: RequestState.loading),
        const TvListState(
          popularTvState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );
  });

  group('Top Rated TV', () {
    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, loaded] ketika data top rated berhasil diambil',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        const TvListState(topRatedTvState: RequestState.loading),
        TvListState(
          topRatedTvState: RequestState.loaded,
          topRatedTv: testTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'harus emit [loading, error] ketika gagal mengambil data top rated',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        const TvListState(topRatedTvState: RequestState.loading),
        const TvListState(
          topRatedTvState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );
  });
}