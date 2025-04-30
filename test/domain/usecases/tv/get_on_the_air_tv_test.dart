import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetOnTheAirTv(mockTvRepository);
  });

  final tTvList = [testTv];

  test('should get list of on the air tv from repository', () async {
    // arrange
    when(
      mockTvRepository.getOnTheAirTv(),
    ).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute();
    // assert
    verify(mockTvRepository.getOnTheAirTv());
    expect(result, Right(tTvList));
  });
}
