import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/module/movie/data/datasource/db/database_helper.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSeries);
  Future<String> removeWatchlist(TvSeriesTable tvSeries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
}

@LazySingleton(as: TvSeriesLocalDataSource)
class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertTvWatchlist(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeTvWatchlist(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    return result != null ? TvSeriesTable.fromMap(result) : null;
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}
