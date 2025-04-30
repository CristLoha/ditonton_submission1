import 'dart:async';
import 'package:ditonton_submission1/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TvDatabaseHelper {
  static TvDatabaseHelper? _databaseHelper;

  TvDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory TvDatabaseHelper() => _databaseHelper ?? TvDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'tv_watchlist';
  static const String _tblCache = 'tv_cache';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'ditonton.db');

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    print('Creating TV database tables...');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblCache (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
    print('TV database tables created successfully');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading TV database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      // Add any new tables or columns here
    }
  }

  static void setDatabaseForTesting(Database? database) {
    _database = database;
  }

  Future<void> insertCacheTransaction(
    List<TvTable> tvs,
    String category,
  ) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in tvs) {
        final tvJson = tv.toJson();
        tvJson['category'] = category;
        txn.insert(_tblCache, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheTvs(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCache,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlist(TvTable tv) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, {
      'id': tv.id,
      'name': tv.name,
      'overview': tv.overview,
      'posterPath': tv.posterPath,
    });
  }

  Future<int> removeWatchlist(TvTable tv) async {
    final db = await database;
    return await db!.delete(_tblWatchlist, where: 'id = ?', whereArgs: [tv.id]);
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
