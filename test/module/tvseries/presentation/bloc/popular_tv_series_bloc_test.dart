import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_popular_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/popular_tv_series_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc bloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state.state, RequestState.empty);
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [loading, loaded] when data is fetched successfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (b) => b.add(const FetchPopularTvSeries()),
    expect: () => [
      const PopularTvSeriesState(state: RequestState.loading),
      PopularTvSeriesState(
          state: RequestState.loaded, tvSeries: testTvSeriesList),
    ],
  );

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [loading, error] when fetch fails',
    build: () {
      when(mockGetPopularTvSeries.execute()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const FetchPopularTvSeries()),
    expect: () => [
      const PopularTvSeriesState(state: RequestState.loading),
      const PopularTvSeriesState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
