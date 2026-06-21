import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_detail_usecase.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(mockRepository);
  });

  const tId = 1;

  test('should get tv series detail from repository', () async {
    when(mockRepository.getTvSeriesDetail(tId))
        .thenAnswer((_) async => const Right(testTvSeriesDetail));

    final result = await usecase.execute(tId);

    expect(result, const Right(testTvSeriesDetail));
    verify(mockRepository.getTvSeriesDetail(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}
