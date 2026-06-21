import 'package:dartz/dartz.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_now_playing_movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test('should get list of movies from the repository', () async {
    when(mockMovieRepository.getNowPlayingMovies())
        .thenAnswer((_) async => Right(tMovies));
    final result = await usecase.execute();
    expect(result, Right(tMovies));
  });
}
