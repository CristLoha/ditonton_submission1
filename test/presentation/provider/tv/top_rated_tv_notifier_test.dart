import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTvNotifier provider;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TopRatedTvNotifier(getTopRatedTv: mockGetTopRatedTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('get top rated tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTopRatedTv();
      // assert
      expect(provider.state, RequestState.loading);
    });

    test('should change tv data when data is gotten successfully', () async {
       // arrange
        when(
          mockGetTopRatedTv.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        // act
        await provider.fetchTopRatedTv();
      // assert
      expect(provider.state, RequestState.loaded);
      expect(provider.tv, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
