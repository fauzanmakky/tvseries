import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_popular_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_top_rated_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_list_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvSeriesListBloc bloc;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TvSeriesListBloc(
      getOnAirTvSeries: mockGetOnAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state, const TvSeriesListState());
    expect(bloc.state.onAirState, RequestState.empty);
    expect(bloc.state.popularState, RequestState.empty);
    expect(bloc.state.topRatedState, RequestState.empty);
  });

  group('FetchOnAirTvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when on air data is fetched successfully',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (b) => b.add(const FetchOnAirTvSeries()),
      expect: () => [
        const TvSeriesListState(onAirState: RequestState.loading),
        TvSeriesListState(
          onAirState: RequestState.loaded,
          onAirTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when on air fetch fails',
      build: () {
        when(mockGetOnAirTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchOnAirTvSeries()),
      expect: () => [
        const TvSeriesListState(onAirState: RequestState.loading),
        const TvSeriesListState(
            onAirState: RequestState.error, message: 'Server Failure'),
      ],
    );
  });

  group('FetchTvSeriesListPopular', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when popular data is fetched successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesListPopular()),
      expect: () => [
        const TvSeriesListState(popularState: RequestState.loading),
        TvSeriesListState(
          popularState: RequestState.loaded,
          popularTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when popular fetch fails',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesListPopular()),
      expect: () => [
        const TvSeriesListState(popularState: RequestState.loading),
        const TvSeriesListState(
            popularState: RequestState.error, message: 'Server Failure'),
      ],
    );
  });

  group('FetchTvSeriesListTopRated', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, loaded] when top rated data is fetched successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesListTopRated()),
      expect: () => [
        const TvSeriesListState(topRatedState: RequestState.loading),
        TvSeriesListState(
          topRatedState: RequestState.loaded,
          topRatedTvSeries: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [loading, error] when top rated fetch fails',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesListTopRated()),
      expect: () => [
        const TvSeriesListState(topRatedState: RequestState.loading),
        const TvSeriesListState(
            topRatedState: RequestState.error, message: 'Server Failure'),
      ],
    );
  });
}
