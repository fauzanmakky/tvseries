import 'package:dartz/dartz.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
          'should get list of movies from the repository when execute function is called',
          () async {
        when(mockMovieRepository.getPopularMovies())
            .thenAnswer((_) async => Right(tMovies));
        final result = await usecase.execute();
        expect(result, Right(tMovies));
      });
    });
  });
}
