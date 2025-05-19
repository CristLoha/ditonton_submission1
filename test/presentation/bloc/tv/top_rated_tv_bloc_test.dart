import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

final tTv = Tv(
  id: 100088,
  name: 'The Last of Us',
  overview:
      'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
  posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
  voteAverage: 8.579,
  voteCount: 5750,
  adult: false,
  backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
  genreIds: [18],
  originalName: 'The Last of Us',
  originCountry: ['US'],
  originalLanguage: 'en',
  popularity: 433.6105,
  firstAirDate: DateTime.parse('2023-01-15'),
);
  final tTvList = <Tv>[tTv];

  test('initial state should be empty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  group('Get Top Rated Tv shows', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [loading, loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => Right(tTvList));
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect:
          () => [TopRatedTvLoading(), TopRatedTvHasData(tTvList)],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [loading, error] when get top rated tv shows is unsuccessful',
      build: () {
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect:
          () => [
            TopRatedTvLoading(),
            const TopRatedTvError('Server Failure'),
          ],
      verify: (_) {
        verify(mockGetTopRatedTv.execute());
      },
    );
  });
}
