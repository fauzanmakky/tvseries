import 'package:injectable/injectable.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';

@injectable
class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
