import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart';

@injectable
class SearchTvSeries {
  final TvSeriesRepository repository;

  SearchTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
