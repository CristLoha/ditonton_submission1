import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:home/home.dart';
import 'get_on_the_air_tv_test.mocks.dart';


void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
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


  final tTvList = [tTv];

  group('GetPopularTv Tests', () {
    group('execute', () {
      test(
        'should get list of popular tv from repository when execute function is called',
        () async {
          // arrange
          when(
            mockTvRepository.getPopularTv(),
          ).thenAnswer((_) async => Right(tTvList));
          // act
          final result = await usecase.execute();
          // assert
          verify(mockTvRepository.getPopularTv());
          expect(result, Right(tTvList));
        },
      );
    });
  });
}
