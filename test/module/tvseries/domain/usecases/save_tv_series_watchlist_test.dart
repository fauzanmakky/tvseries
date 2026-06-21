import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/save_tv_series_watchlist_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = SaveTvSeriesWatchlist(mockRepository);
  });

  test('should save tv series to watchlist via repository', () async {
    when(mockRepository.saveWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.execute(testTvSeriesDetail);

    expect(result, const Right('Added to Watchlist'));
    verify(mockRepository.saveWatchlist(testTvSeriesDetail));
    verifyNoMoreInteractions(mockRepository);
  });
}
