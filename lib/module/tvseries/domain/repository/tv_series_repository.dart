import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getOnAirTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, TvSeriesSeason>> getTvSeriesSeasonDetail(
      int tvId, int seasonNumber);
  Future<Either<Failure, String>> saveWatchlist(TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvSeriesDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
}
