import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_watchlist_tv_series_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockRepository);
  });

  test('should get list of watchlist tv series from repository', () async {
    when(mockRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTvSeriesList));
    verify(mockRepository.getWatchlistTvSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
