import 'package:ditonton_submission1/features/tv/data/datasources/db/tv_database_helper.dart';
import 'package:home/data/models/tv_table.dart';
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
    test('should be a singleton', () {
      // arrange
      final instance1 = TvDatabaseHelper();
      final instance2 = TvDatabaseHelper();

      // assert
      expect(instance1, instance2);
    });

    test('should initialize database correctly', () async {
      // act
      final db = await databaseHelper.database;

      // assert
      expect(db, isNotNull);
      expect(db, equals(database));
    });

    test('should create tables correctly', () async {
      // act
      final db = await databaseHelper.database;
      final tables = await db!.query(
        'sqlite_master',
        where: 'type = ?',
        whereArgs: ['table'],
      );

      // assert
      expect(tables.length, 2);
      expect(tables.any((table) => table['name'] == 'tv_watchlist'), isTrue);
      expect(tables.any((table) => table['name'] == 'tv_cache'), isTrue);
    });

    test('should handle database upgrade correctly', () async {
      // arrange
      await database.close();
      database = await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 2,
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
          onUpgrade: (db, oldVersion, newVersion) async {
            if (oldVersion < 2) {
              // Add any upgrade logic here
              await db.execute(
                'ALTER TABLE tv_watchlist ADD COLUMN newColumn TEXT',
              );
            }
          },
        ),
      );
      TvDatabaseHelper.setDatabaseForTesting(database);

      // Insert test data
      final tv = TvTable(
        id: 1,
        name: 'test',
        overview: 'test',
        posterPath: 'test',
      );
      await database.insert('tv_watchlist', tv.toJson());

      // act
      final db = await databaseHelper.database;
      final columns = await db!.query('tv_watchlist');

      // assert
      expect(columns.isNotEmpty, isTrue);
      expect(columns.first['id'], 1);
      expect(columns.first['name'], 'test');
      expect(columns.first['overview'], 'test');
      expect(columns.first['posterPath'], 'test');
    });

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

      test('should throw error when inserting duplicate tv', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await databaseHelper.insertWatchlist(tv);

        // act & assert
        expect(() => databaseHelper.insertWatchlist(tv), throwsException);
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

      test('should return 0 when removing non-existent tv', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'test',
          overview: 'test',
          posterPath: 'test',
        );

        // act
        final result = await databaseHelper.removeWatchlist(tv);

        // assert
        expect(result, 0);
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

      test('should return empty list when watchlist is empty', () async {
        // act
        final result = await databaseHelper.getWatchlistTvs();

        // assert
        expect(result, isEmpty);
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

      test('should handle multiple tvs in cache transaction', () async {
        // arrange
        final tvs = [
          TvTable(id: 1, name: 'test1', overview: 'test1', posterPath: 'test1'),
          TvTable(id: 2, name: 'test2', overview: 'test2', posterPath: 'test2'),
        ];

        // act
        await databaseHelper.insertCacheTransaction(tvs, 'on the air');
        final result = await databaseHelper.getCacheTvs('on the air');

        // assert
        expect(result.length, 2);
        expect(result[0]['id'], tvs[0].id);
        expect(result[1]['id'], tvs[1].id);
      });

      test('should return empty list for non-existent category', () async {
        // act
        final result = await databaseHelper.getCacheTvs('non-existent');

        // assert
        expect(result, isEmpty);
      });

      test('should return 0 when clearing non-existent category', () async {
        // act
        final result = await databaseHelper.clearCache('non-existent');

        // assert
        expect(result, 0);
      });
    });

    group('Database Initialization', () {
      test(
        'should initialize database with correct path and version',
        () async {
          // arrange
          await database.close();
          TvDatabaseHelper.setDatabaseForTesting(null);

          // act
          final db = await databaseHelper.database;

          // assert
          expect(db, isNotNull);
          final tables = await db!.query(
            'sqlite_master',
            where: 'type = ?',
            whereArgs: ['table'],
          );
          expect(tables.length, 2);
          expect(
            tables.any((table) => table['name'] == 'tv_watchlist'),
            isTrue,
          );
          expect(tables.any((table) => table['name'] == 'tv_cache'), isTrue);
        },
      );

      test(
        'should create tables with correct schema on database creation',
        () async {
          // arrange
          await database.close();
          TvDatabaseHelper.setDatabaseForTesting(null);

          // act
          final db = await databaseHelper.database;

          // assert
          // Check tv_watchlist table schema
          final watchlistTableInfo = await db!.rawQuery(
            'PRAGMA table_info(tv_watchlist)',
          );
          expect(watchlistTableInfo.length, 4);
          expect(watchlistTableInfo[0]['name'], 'id');
          expect(watchlistTableInfo[1]['name'], 'name');
          expect(watchlistTableInfo[2]['name'], 'overview');
          expect(watchlistTableInfo[3]['name'], 'posterPath');

          // Check tv_cache table schema
          final cacheTableInfo = await db.rawQuery(
            'PRAGMA table_info(tv_cache)',
          );
          expect(cacheTableInfo.length, 5);
          expect(cacheTableInfo[0]['name'], 'id');
          expect(cacheTableInfo[1]['name'], 'name');
          expect(cacheTableInfo[2]['name'], 'overview');
          expect(cacheTableInfo[3]['name'], 'posterPath');
          expect(cacheTableInfo[4]['name'], 'category');
        },
      );

      test('should handle database upgrade without data loss', () async {
        // arrange
        final tv = TvTable(
          id: 1,
          name: 'Test Show',
          overview: 'Test Overview',
          posterPath: 'test.jpg',
        );

        // Create a temporary database file
        final dbPath = '${await getDatabasesPath()}/test_tv.db';

        // Make sure we start fresh
        await databaseFactoryFfi.deleteDatabase(dbPath);

        // Create version 1 database
        database = await databaseFactoryFfi.openDatabase(
          dbPath,
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

        TvDatabaseHelper.setDatabaseForTesting(database);

        // Insert test data
        final result = await databaseHelper.insertWatchlist(tv);
        expect(result, 1);

        // Close database
        await database.close();

        // Reopen with version 2
        database = await databaseFactoryFfi.openDatabase(
          dbPath,
          options: OpenDatabaseOptions(
            version: 2,
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

        TvDatabaseHelper.setDatabaseForTesting(database);

        // act
        final storedTv = await databaseHelper.getTvById(1);

        // Clean up
        await databaseFactoryFfi.deleteDatabase(dbPath);

        // assert
        expect(storedTv, isNotNull);
        expect(storedTv!['id'], 1);
        expect(storedTv['name'], 'Test Show');
        expect(storedTv['overview'], 'Test Overview');
        expect(storedTv['posterPath'], 'test.jpg');
      });
    });
  });
}
