import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTopRatedTv(mockTvRepository);
  });

  final tTvList = [testTv];

  test('should get list of top rated tv from repository', () async {
    // arrange
    when(
      mockTvRepository.getTopRatedTv(),
    ).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute();
    // assert
    verify(mockTvRepository.getTopRatedTv());
    expect(result, Right(tTvList));
  });
}
