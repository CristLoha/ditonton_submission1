import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:mockito/mockito.dart';
import '../../../../test/dummy_data/dummy_objects.dart';
import '../../../../test/helpers/test_helper.mocks.dart';

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
