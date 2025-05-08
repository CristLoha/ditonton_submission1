import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';




void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvNotifier provider;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    provider = PopularTvNotifier(mockGetPopularTv)..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('get popular tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchPopularTv();
      // assert
      expect(provider.state, RequestState.loading);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.state, RequestState.loaded);
      expect(provider.tv, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
