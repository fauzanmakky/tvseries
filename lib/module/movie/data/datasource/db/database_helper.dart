import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tvseries/module/movie/data/model/movie_table.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_table.dart';

@lazySingleton
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblTvWatchlist = 'tv_watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/tvseries.db';

    return openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblTvWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $_tblTvWatchlist (
          id INTEGER PRIMARY KEY,
          name TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');
    }
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    return await db!.query(_tblWatchlist);
  }

  Future<int> insertTvWatchlist(TvSeriesTable tvSeries) async {
    final db = await database;
    return await db!.insert(_tblTvWatchlist, tvSeries.toJson());
  }

  Future<int> removeTvWatchlist(TvSeriesTable tvSeries) async {
    final db = await database;
    return await db!.delete(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblTvWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    return await db!.query(_tblTvWatchlist);
  }
}
