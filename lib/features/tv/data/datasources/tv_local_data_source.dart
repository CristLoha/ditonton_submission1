import 'package:core/core.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/db/tv_database_helper.dart';
import 'package:home/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<void> cacheOnTheAirTv(List<TvTable> tvs);
  Future<List<TvTable>> getCachedOnTheAirTv();
  Future<String> insertWatchlist(TvTable tv);
  Future<String> removeWatchlist(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final TvDatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvTable tv) async {
    try {
      await databaseHelper.insertWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tv) async {
    try {
      await databaseHelper.removeWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final result = await databaseHelper.getWatchlistTvs();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheOnTheAirTv(List<TvTable> tvs) async {
    await databaseHelper.clearCache('on the air');
    await databaseHelper.insertCacheTransaction(tvs, 'on the air');
  }

  @override
  Future<List<TvTable>> getCachedOnTheAirTv() async {
    final result = await databaseHelper.getCacheTvs('on the air');
    if (result.isNotEmpty) {
      return result.map((data) => TvTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get data");
    }
  }
}
