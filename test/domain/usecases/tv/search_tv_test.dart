import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(mockTvRepository);
  });

  final tQuery = 'The Last of Us';
  final tTvList = [testTv];

  test('should get list of tv from repository', () async {
    // arrange
    when(
      mockTvRepository.searchTv(tQuery),
    ).thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    verify(mockTvRepository.searchTv(tQuery));
    expect(result, Right(tTvList));
  });
}
