import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_recommendations_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockRepository);
  });

  const tId = 1;

  test('should get list of tv series recommendations from repository',
      () async {
    when(mockRepository.getTvSeriesRecommendations(tId))
        .thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute(tId);

    expect(result, Right(testTvSeriesList));
    verify(mockRepository.getTvSeriesRecommendations(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}
