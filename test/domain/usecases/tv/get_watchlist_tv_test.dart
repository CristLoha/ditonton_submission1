import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListTv(mockTvRepository);
  });

  final tTvList = [testWatchlistTv];

  test('should get list of tv from the repository', () async {
    // arrange
    when(
      mockTvRepository.getWatchlistTv(),
    ).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute();
    // assert
    verify(mockTvRepository.getWatchlistTv());
    expect(result, Right(tTvList));
  });
}
