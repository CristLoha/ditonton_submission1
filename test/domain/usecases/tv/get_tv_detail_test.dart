import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  final tId = 1;

  test('should get tv detail from repository', () async {
    // arrange
    when(
      mockTvRepository.getTvDetail(tId),
    ).thenAnswer((_) async => Right(testTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    verify(mockTvRepository.getTvDetail(tId));
    expect(result, Right(testTvDetail));
  });
}
