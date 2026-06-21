import 'package:dartz/dartz.dart';
import 'package:tvseries/module/movie/domain/usecase/remove_watchlist_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    when(mockMovieRepository.removeWatchlist(testMovieDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    final result = await usecase.execute(testMovieDetail);
    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
