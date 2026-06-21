import 'package:injectable/injectable.dart';
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart';

@injectable
class GetTvSeriesWatchlistStatus {
  final TvSeriesRepository repository;

  GetTvSeriesWatchlistStatus(this.repository);

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
