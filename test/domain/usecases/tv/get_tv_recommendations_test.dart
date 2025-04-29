import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  final tId = 1;
  final tTvList = [testTv];

  test('should get list of tv recommendations from repository', () async {
    // arrange
    when(
      mockTvRepository.getTvRecommendations(tId),
    ).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tId);
    // assert
    verify(mockTvRepository.getTvRecommendations(tId));
    expect(result, Right(tTvList));
  });
}

