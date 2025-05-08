import 'package:core/core.dart';
import 'package:ditonton_submission1/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockTvDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockTvDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlist(any),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlist(testTvTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.insertWatchlist(any)).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlist(testTvTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(any),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlist(testTvTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlist(testTvTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlist(testTvTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get Movie Detail By Id', () {
    final tId = 45789;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTvById(tId),
      ).thenAnswer((_) async => testTvMap);

      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, null);
    });
  });

  group('Get Watchlist Tv', () {
    test('should return list of TvTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistTvs(),
      ).thenAnswer((_) async => [testTvMap]);
      // act
      final result = await dataSource.getWatchlistTvs();
      // assert
      expect(result, [testTvTable]);
    });

    group('cache now playing movies', () {
      test('should call database helper to save data', () async {
        // arrange
        when(
          mockDatabaseHelper.clearCache('on the air'),
        ).thenAnswer((_) async => 1);
        // act
        await dataSource.cacheOnTheAirTv([testTvTable]);
        // assert
        verify(mockDatabaseHelper.clearCache('on the air'));
        verify(
          mockDatabaseHelper.insertCacheTransaction([
            testTvTable,
          ], 'on the air'),
        );
      });

      test('should return list of tv from db when data exist', () async {
        // arrange
        when(
          mockDatabaseHelper.getCacheTvs('on the air'),
        ).thenAnswer((_) async => [testTvCacheMap]);
        // act
        final result = await dataSource.getCachedOnTheAirTv();
        // assert
        expect(result, [testTvCache]);
      });

      test(
        'should throw CacheException when cache data is not exist',
        () async {
          // arrange
          when(
            mockDatabaseHelper.getCacheTvs('on the air'),
          ).thenAnswer((_) async => []);
          // act
          final call = dataSource.getCachedOnTheAirTv();
          // assert
          expect(() => call, throwsA(isA<CacheException>()));
        },
      );
    });
  });
}
