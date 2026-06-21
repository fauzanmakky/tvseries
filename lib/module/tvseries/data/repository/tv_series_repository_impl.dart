import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/tvseries/data/datasource/local_datasource/tv_series_local_datasource.dart';
import 'package:tvseries/module/tvseries/data/datasource/remote_datasource/tv_series_remote_datasource.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_table.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart';

@LazySingleton(as: TvSeriesRepository)
class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getOnAirTvSeries() async {
    try {
      final result = await remoteDataSource.getOnAirTvSeries();
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await remoteDataSource.getPopularTvSeries();
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTvSeries();
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeries(query);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvSeriesSeason>> getTvSeriesSeasonDetail(
      int tvId, int seasonNumber) async {
    try {
      final result =
          await remoteDataSource.getTvSeriesSeasonDetail(tvId, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(message: ''));
    } on SocketException {
      return Left(ConnectionFailure(message: 'Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .insertWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .removeWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
