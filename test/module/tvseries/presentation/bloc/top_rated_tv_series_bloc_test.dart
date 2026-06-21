import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_top_rated_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/top_rated_tv_series_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesBloc bloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state.state, RequestState.empty);
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [loading, loaded] when data is fetched successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (b) => b.add(const FetchTopRatedTvSeries()),
    expect: () => [
      const TopRatedTvSeriesState(state: RequestState.loading),
      TopRatedTvSeriesState(
          state: RequestState.loaded, tvSeries: testTvSeriesList),
    ],
  );

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [loading, error] when fetch fails',
    build: () {
      when(mockGetTopRatedTvSeries.execute()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const FetchTopRatedTvSeries()),
    expect: () => [
      const TopRatedTvSeriesState(state: RequestState.loading),
      const TopRatedTvSeriesState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
