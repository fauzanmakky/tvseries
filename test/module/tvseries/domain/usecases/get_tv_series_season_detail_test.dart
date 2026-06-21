import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_season_detail_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesSeasonDetail usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesSeasonDetail(mockTvSeriesRepository);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;

  test('should get season detail from the repository', () async {
    when(mockTvSeriesRepository.getTvSeriesSeasonDetail(
            tTvId, tSeasonNumber))
        .thenAnswer((_) async => const Right(testTvSeriesSeason));

    final result = await usecase.execute(tTvId, tSeasonNumber);

    expect(result, const Right(testTvSeriesSeason));
    verify(mockTvSeriesRepository.getTvSeriesSeasonDetail(
        tTvId, tSeasonNumber));
    verifyNoMoreInteractions(mockTvSeriesRepository);
  });
}
