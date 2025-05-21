import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvBloc searchBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchBloc = SearchTvBloc(mockSearchTv);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchTvEmpty());
  });

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

  final testTvList = [tTv];

  final tQuery = 'The Last of Us';
  group('SearchTvBloc', () {
    blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(
          mockSearchTv.execute(tQuery),
        ).thenAnswer((_) async => Right(testTvList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(OnQueryTvChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SearchTvLoading(), SearchTvHasData(testTvList)],
      verify: (bloc) {
        verify(mockSearchTv.execute(tQuery));
      },
    );
  });
}
