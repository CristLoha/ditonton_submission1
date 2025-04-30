import 'package:ditonton_submission1/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton_submission1/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late TvDatabaseHelper databaseHelper;
  late Database database;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Create a new in-memory database for each test
    database = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tv_watchlist (
              id INTEGER PRIMARY KEY,
              name TEXT,
              overview TEXT,
              posterPath TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE tv_cache (
              id INTEGER PRIMARY KEY,
              name TEXT,
              overview TEXT,
              posterPath TEXT,
              category TEXT
            );
          ''');
        },
      ),
    );

    // Create a new instance for each test
    databaseHelper = TvDatabaseHelper();
    // Set the test database
    TvDatabaseHelper.setDatabaseForTesting(database);
  });

  tearDown(() async {
    await database.close();
    TvDatabaseHelper.setDatabaseForTesting(null);
  });

  group('TvDatabaseHelper', () {
    group('insertWatchlist', () {
      test('should insert tv to watchlist table', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );

        // act
        final result = await databaseHelper.insertWatchlist(tv);

        // assert
        expect(result, 1);
        final tvs = await database.query('tv_watchlist');
        expect(tvs.length, 1);
        expect(tvs.first['id'], tv.id);
        expect(tvs.first['name'], tv.name);
        expect(tvs.first['overview'], tv.overview);
        expect(tvs.first['posterPath'], tv.posterPath);
      });
    });

    group('removeWatchlist', () {
      test('should remove tv from watchlist table', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('tv_watchlist', tv.toJson());

        // act
        final result = await databaseHelper.removeWatchlist(tv);

        // assert
        expect(result, 1);
        final tvs = await database.query('tv_watchlist');
        expect(tvs, isEmpty);
      });
    });

    group('getTvById', () {
      test('should return tv when tv exists in watchlist', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('tv_watchlist', tv.toJson());

        // act
        final result = await databaseHelper.getTvById(tv.id);

        // assert
        expect(result, isNotNull);
        expect(result!['id'], tv.id);
        expect(result['name'], tv.name);
        expect(result['overview'], tv.overview);
        expect(result['posterPath'], tv.posterPath);
      });

      test('should return null when tv does not exist in watchlist', () async {
        // act
        final result = await databaseHelper.getTvById(1);
        // assert
        expect(result, null);
      });
    });

    group('getWatchlistTvs', () {
      test('should return list of tvs from watchlist', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('tv_watchlist', tv.toJson());

        // act
        final result = await databaseHelper.getWatchlistTvs();

        // assert
        expect(result.length, 1);
        expect(result.first['id'], tv.id);
        expect(result.first['name'], tv.name);
        expect(result.first['overview'], tv.overview);
        expect(result.first['posterPath'], tv.posterPath);
      });
    });

    group('cache operations', () {
      test('should insert and retrieve tvs from cache', () async {
        // arrange
        final tvs = [
          TvTable(id: 1, name: 'test', overview: 'test', posterPath: 'test'),
        ];

        // act
        await databaseHelper.insertCacheTransaction(tvs, 'on the air');
        final result = await databaseHelper.getCacheTvs('on the air');

        // assert
        expect(result.length, 1);
        expect(result.first['id'], tvs.first.id);
        expect(result.first['name'], tvs.first.name);
        expect(result.first['overview'], tvs.first.overview);
        expect(result.first['posterPath'], tvs.first.posterPath);
        expect(result.first['category'], 'on the air');
      });

      test('should clear cache by category', () async {
        // arrange
        final tvs = [
          TvTable(id: 1, name: 'test', overview: 'test', posterPath: 'test'),
        ];
        await databaseHelper.insertCacheTransaction(tvs, 'on the air');

        // act
        final result = await databaseHelper.clearCache('on the air');

        // assert
        expect(result, 1);
        final cachedTvs = await database.query('tv_cache');
        expect(cachedTvs, isEmpty);
      });
    });
  });
}
