import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/search_tv_series_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockRepository);
  });

  const tQuery = 'Stranger Things';

  test('should search tv series from repository with given query', () async {
    when(mockRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute(tQuery);

    expect(result, Right(testTvSeriesList));
    verify(mockRepository.searchTvSeries(tQuery));
    verifyNoMoreInteractions(mockRepository);
  });
}
