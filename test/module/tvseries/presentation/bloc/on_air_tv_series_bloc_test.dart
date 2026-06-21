import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/on_air_tv_series_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'on_air_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries])
void main() {
  late OnAirTvSeriesBloc bloc;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    bloc = OnAirTvSeriesBloc(mockGetOnAirTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state.state, RequestState.empty);
  });

  blocTest<OnAirTvSeriesBloc, OnAirTvSeriesState>(
    'should emit [loading, loaded] when data is fetched successfully',
    build: () {
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (b) => b.add(const FetchOnAirTvSeriesList()),
    expect: () => [
      const OnAirTvSeriesState(state: RequestState.loading),
      OnAirTvSeriesState(
          state: RequestState.loaded, tvSeries: testTvSeriesList),
    ],
  );

  blocTest<OnAirTvSeriesBloc, OnAirTvSeriesState>(
    'should emit [loading, error] when fetch fails',
    build: () {
      when(mockGetOnAirTvSeries.execute()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const FetchOnAirTvSeriesList()),
    expect: () => [
      const OnAirTvSeriesState(state: RequestState.loading),
      const OnAirTvSeriesState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
