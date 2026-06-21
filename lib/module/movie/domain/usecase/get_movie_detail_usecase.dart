import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/module/movie/domain/entity/movie_detail_entity.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';
import 'package:tvseries/commons/error/failure.dart';

@injectable
class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
