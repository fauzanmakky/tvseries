import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/search_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_search_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries: mockSearchTvSeries);
  });

  tearDown(() => bloc.close());

  const tQuery = 'Stranger Things';

  test('initial state should be empty', () {
    expect(bloc.state.state, RequestState.empty);
    expect(bloc.state.searchResult, []);
  });

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'should emit [loading, loaded] when search is successful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (b) => b.add(const SearchTvSeriesEvent(tQuery)),
    expect: () => [
      const TvSeriesSearchState(state: RequestState.loading),
      TvSeriesSearchState(
          state: RequestState.loaded, searchResult: testTvSeriesList),
    ],
  );

  blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
    'should emit [loading, error] when search fails',
    build: () {
      when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const SearchTvSeriesEvent(tQuery)),
    expect: () => [
      const TvSeriesSearchState(state: RequestState.loading),
      const TvSeriesSearchState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
