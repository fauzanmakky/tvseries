import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';
import 'package:tvseries/commons/error/failure.dart';

@injectable
class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
