import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';
import 'package:tvseries/commons/error/failure.dart';

@injectable
class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
