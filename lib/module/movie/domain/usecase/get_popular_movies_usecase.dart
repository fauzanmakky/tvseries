import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';

@injectable
class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
