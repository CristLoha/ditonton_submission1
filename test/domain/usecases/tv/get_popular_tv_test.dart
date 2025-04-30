import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
  });

  final tTvList = [testTv];

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
