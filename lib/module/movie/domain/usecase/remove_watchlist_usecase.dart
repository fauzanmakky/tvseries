import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/movie/domain/entity/movie_detail_entity.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';

@injectable
class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
