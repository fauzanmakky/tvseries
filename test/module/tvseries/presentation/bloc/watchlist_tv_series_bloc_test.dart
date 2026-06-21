import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_watchlist_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/watchlist_tv_series_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(getWatchlistTvSeries: mockGetWatchlistTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state.watchlistState, RequestState.empty);
    expect(bloc.state.watchlistTvSeries, []);
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [loading, loaded] when watchlist is fetched successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (b) => b.add(const FetchWatchlistTvSeries()),
    expect: () => [
      const WatchlistTvSeriesState(watchlistState: RequestState.loading),
      WatchlistTvSeriesState(
        watchlistState: RequestState.loaded,
        watchlistTvSeries: testTvSeriesList,
      ),
    ],
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [loading, error] when fetch fails',
    build: () {
      when(mockGetWatchlistTvSeries.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure(message: 'Database error')));
      return bloc;
    },
    act: (b) => b.add(const FetchWatchlistTvSeries()),
    expect: () => [
      const WatchlistTvSeriesState(watchlistState: RequestState.loading),
      const WatchlistTvSeriesState(
          watchlistState: RequestState.error, message: 'Database error'),
    ],
  );
}
