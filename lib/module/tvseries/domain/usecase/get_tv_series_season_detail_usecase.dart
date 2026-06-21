import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart';

@injectable
class GetTvSeriesSeasonDetail {
  final TvSeriesRepository repository;

  GetTvSeriesSeasonDetail(this.repository);

  Future<Either<Failure, TvSeriesSeason>> execute(
          int tvId, int seasonNumber) =>
      repository.getTvSeriesSeasonDetail(tvId, seasonNumber);
}
