import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnAirTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetOnAirTvSeries(mockRepository);
  });

  test('should get list of on air tv series from repository', () async {
    when(mockRepository.getOnAirTvSeries())
        .thenAnswer((_) async => Right(testTvSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTvSeriesList));
    verify(mockRepository.getOnAirTvSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
