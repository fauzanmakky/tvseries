import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_watchlist_status_usecase.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesWatchlistStatus usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesWatchlistStatus(mockRepository);
  });

  const tId = 1;

  test('should return watchlist status from repository', () async {
    when(mockRepository.isAddedToWatchlist(tId)).thenAnswer((_) async => true);

    final result = await usecase.execute(tId);

    expect(result, true);
    verify(mockRepository.isAddedToWatchlist(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}
