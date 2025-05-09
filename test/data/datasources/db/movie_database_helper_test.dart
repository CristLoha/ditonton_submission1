import 'package:ditonton_submission1/features/movies/data/datasources/db/movie_database_helper.dart';
import 'package:home/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late MovieDatabaseHelper databaseHelper;
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
            CREATE TABLE watchlist (
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE cache (
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT,
              category TEXT
            );
          ''');
        },
      ),
    );

    // Create a new instance for each test
    databaseHelper = MovieDatabaseHelper();
    // Set the test database
    MovieDatabaseHelper.setDatabaseForTesting(database);
  });

  tearDown(() async {
    await database.close();
    MovieDatabaseHelper.setDatabaseForTesting(null);
  });

  group('MovieDatabaseHelper', () {
    test('should be a singleton', () {
      // arrange
      final instance1 = MovieDatabaseHelper();
      final instance2 = MovieDatabaseHelper();

      // assert
      expect(instance1, instance2);
    });

    group('insertWatchlist', () {
      test('should insert movie to watchlist table', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );

        // act
        final result = await databaseHelper.insertWatchlist(movie);

        // assert
        expect(result, 1);
        final movies = await database.query('watchlist');
        expect(movies.length, 1);
        expect(movies.first['id'], movie.id);
        expect(movies.first['title'], movie.title);
        expect(movies.first['overview'], movie.overview);
        expect(movies.first['posterPath'], movie.posterPath);
      });

      test('should throw error when inserting duplicate movie', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await databaseHelper.insertWatchlist(movie);

        // act & assert
        expect(() => databaseHelper.insertWatchlist(movie), throwsException);
      });
    });

    group('removeWatchlist', () {
      test('should remove movie from watchlist table', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('watchlist', movie.toJson());

        // act
        final result = await databaseHelper.removeWatchlist(movie);

        // assert
        expect(result, 1);
        final movies = await database.query('watchlist');
        expect(movies, isEmpty);
      });

      test('should return 0 when removing non-existent movie', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );

        // act
        final result = await databaseHelper.removeWatchlist(movie);

        // assert
        expect(result, 0);
      });
    });

    group('getMovieById', () {
      test('should return movie when movie exists in watchlist', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('watchlist', movie.toJson());

        // act
        final result = await databaseHelper.getMovieById(movie.id);

        // assert
        expect(result, isNotNull);
        expect(result!['id'], movie.id);
        expect(result['title'], movie.title);
        expect(result['overview'], movie.overview);
        expect(result['posterPath'], movie.posterPath);
      });

      test(
        'should return null when movie does not exist in watchlist',
        () async {
          // act
          final result = await databaseHelper.getMovieById(1);
          // assert
          expect(result, null);
        },
      );
    });

    group('getWatchlistMovies', () {
      test('should return list of movies from watchlist', () async {
        // arrange
        final movie = MovieTable(
          id: 1,
          title: 'test',
          overview: 'test',
          posterPath: 'test',
        );
        await database.insert('watchlist', movie.toJson());

        // act
        final result = await databaseHelper.getWatchlistMovies();

        // assert
        expect(result.length, 1);
        expect(result.first['id'], movie.id);
        expect(result.first['title'], movie.title);
        expect(result.first['overview'], movie.overview);
        expect(result.first['posterPath'], movie.posterPath);
      });

      test('should return empty list when watchlist is empty', () async {
        // act
        final result = await databaseHelper.getWatchlistMovies();

        // assert
        expect(result, isEmpty);
      });
    });

    group('cache operations', () {
      test('should insert and retrieve movies from cache', () async {
        // arrange
        final movies = [
          MovieTable(
            id: 1,
            title: 'test',
            overview: 'test',
            posterPath: 'test',
          ),
        ];

        // act
        await databaseHelper.insertCacheTransaction(movies, 'now playing');
        final result = await databaseHelper.getCacheMovies('now playing');

        // assert
        expect(result.length, 1);
        expect(result.first['id'], movies.first.id);
        expect(result.first['title'], movies.first.title);
        expect(result.first['overview'], movies.first.overview);
        expect(result.first['posterPath'], movies.first.posterPath);
        expect(result.first['category'], 'now playing');
      });

      test('should clear cache by category', () async {
        // arrange
        final movies = [
          MovieTable(
            id: 1,
            title: 'test',
            overview: 'test',
            posterPath: 'test',
          ),
        ];
        await databaseHelper.insertCacheTransaction(movies, 'now playing');

        // act
        final result = await databaseHelper.clearCache('now playing');

        // assert
        expect(result, 1);
        final cachedMovies = await database.query('cache');
        expect(cachedMovies, isEmpty);
      });

      test('should handle multiple movies in cache transaction', () async {
        // arrange
        final movies = [
          MovieTable(
            id: 1,
            title: 'test1',
            overview: 'test1',
            posterPath: 'test1',
          ),
          MovieTable(
            id: 2,
            title: 'test2',
            overview: 'test2',
            posterPath: 'test2',
          ),
        ];

        // act
        await databaseHelper.insertCacheTransaction(movies, 'now playing');
        final result = await databaseHelper.getCacheMovies('now playing');

        // assert
        expect(result.length, 2);
        expect(result[0]['id'], movies[0].id);
        expect(result[1]['id'], movies[1].id);
      });

      test('should return empty list for non-existent category', () async {
        // act
        final result = await databaseHelper.getCacheMovies('non-existent');

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
  });
}
