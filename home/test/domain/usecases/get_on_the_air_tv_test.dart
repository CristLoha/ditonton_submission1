import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import '../../../../test/dummy_data/dummy_objects.dart';
import '../../../../test/helpers/test_helper.mocks.dart';

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
