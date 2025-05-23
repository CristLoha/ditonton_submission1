import 'package:bloc_test/bloc_test.dart';
import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/test_helper.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  group('get popular tv shows', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvData()),
      expect: () => [PopularTvLoading(), PopularTvHasData(testTvList)],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [loading, error] when get top rated movies is unsuccessful',
      build: () {
        when(
          mockGetPopularTv.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Error message')));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvData()),
      expect: () => [PopularTvLoading(), const PopularTvError('Error message')],
      verify: (_) {
        verify(mockGetPopularTv.execute());
      },
    );
  });
}
