import 'package:ditonton_submission1/presentation/provider/tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchTv mockSearchTv;
  late TvSearchNotifier provider;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv)..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tQuery = 'The Last of Us';

  group('search tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change search data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchTv.execute(tQuery),
        ).thenAnswer((_) async => Right(testTvList));
        // act
        await provider.fetchTvSearch(tQuery);
        // assert
        expect(provider.searchResult, testTvList);
        expect(provider.state, RequestState.loaded);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSearch(tQuery);
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
