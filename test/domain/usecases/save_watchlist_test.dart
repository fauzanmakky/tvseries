import 'package:dartz/dartz.dart';
import 'package:tvseries/module/movie/domain/usecase/save_watchlist_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(mockMovieRepository);
  });

  test('should save movie to the repository', () async {
    when(mockMovieRepository.saveWatchlist(testMovieDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    final result = await usecase.execute(testMovieDetail);
    verify(mockMovieRepository.saveWatchlist(testMovieDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
