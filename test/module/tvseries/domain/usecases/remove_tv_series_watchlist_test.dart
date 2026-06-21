import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/remove_tv_series_watchlist_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = RemoveTvSeriesWatchlist(mockRepository);
  });

  test('should remove tv series from watchlist via repository', () async {
    when(mockRepository.removeWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(testTvSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
    verify(mockRepository.removeWatchlist(testTvSeriesDetail));
    verifyNoMoreInteractions(mockRepository);
  });
}
