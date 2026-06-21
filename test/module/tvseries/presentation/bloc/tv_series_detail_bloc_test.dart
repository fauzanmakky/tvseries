import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_detail_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_recommendations_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_season_detail_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_watchlist_status_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/remove_tv_series_watchlist_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/save_tv_series_watchlist_usecase.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_detail_bloc.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetTvSeriesWatchlistStatus,
  SaveTvSeriesWatchlist,
  RemoveTvSeriesWatchlist,
  GetTvSeriesSeasonDetail,
])
void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late MockGetTvSeriesSeasonDetail mockGetTvSeriesSeasonDetail;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    mockGetTvSeriesSeasonDetail = MockGetTvSeriesSeasonDetail();
    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getTvSeriesWatchlistStatus: mockGetTvSeriesWatchlistStatus,
      saveTvSeriesWatchlist: mockSaveTvSeriesWatchlist,
      removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist,
      getTvSeriesSeasonDetail: mockGetTvSeriesSeasonDetail,
    );
  });

  tearDown(() => bloc.close());

  const tId = 1;

  void arrangeUsecase() {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => const Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesList));
    when(mockGetTvSeriesSeasonDetail.execute(tId, 1))
        .thenAnswer((_) async => const Right(testTvSeriesSeason));
  }

  group('FetchTvSeriesDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, loaded, season loading, season loaded] when all fetches succeed',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: testTvSeriesList,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: testTvSeriesList,
          seasonDetailState: RequestState.loading,
          selectedSeason: 1,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: testTvSeriesList,
          seasonDetailState: RequestState.loaded,
          seasonDetail: testTvSeriesSeason,
          selectedSeason: 1,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [loading, error] when detail fetch fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        const TvSeriesDetailState(
            tvSeriesState: RequestState.error, message: 'Server Failure'),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit recommendation error when recommendation fetch fails',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Failed')));
        when(mockGetTvSeriesSeasonDetail.execute(tId, 1))
            .thenAnswer((_) async => const Right(testTvSeriesSeason));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvSeriesState: RequestState.loading),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
          seasonDetailState: RequestState.loading,
          selectedSeason: 1,
        ),
        TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
          seasonDetailState: RequestState.loaded,
          seasonDetail: testTvSeriesSeason,
          selectedSeason: 1,
        ),
      ],
    );
  });

  group('FetchTvSeriesSeasonDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [season loading, season loaded] when fetch season succeeds',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, 1))
            .thenAnswer((_) async => const Right(testTvSeriesSeason));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesSeasonDetail(tId, 1)),
      expect: () => [
        const TvSeriesDetailState(
          seasonDetailState: RequestState.loading,
          selectedSeason: 1,
        ),
        const TvSeriesDetailState(
          seasonDetailState: RequestState.loaded,
          seasonDetail: testTvSeriesSeason,
          selectedSeason: 1,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [season loading, season error] when fetch season fails',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, 1)).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesSeasonDetail(tId, 1)),
      expect: () => [
        const TvSeriesDetailState(
          seasonDetailState: RequestState.loading,
          selectedSeason: 1,
        ),
        const TvSeriesDetailState(
          seasonDetailState: RequestState.error,
          message: 'Server Failure',
          selectedSeason: 1,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should update selectedSeason when fetching different season',
      build: () {
        when(mockGetTvSeriesSeasonDetail.execute(tId, 2))
            .thenAnswer((_) async => const Right(testTvSeriesSeason));
        return bloc;
      },
      act: (b) => b.add(const FetchTvSeriesSeasonDetail(tId, 2)),
      expect: () => [
        const TvSeriesDetailState(
          seasonDetailState: RequestState.loading,
          selectedSeason: 2,
        ),
        const TvSeriesDetailState(
          seasonDetailState: RequestState.loaded,
          seasonDetail: testTvSeriesSeason,
          selectedSeason: 2,
        ),
      ],
    );
  });

  group('LoadTvSeriesWatchlistStatus', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit isAddedToWatchlist true when status is true',
      build: () {
        when(mockGetTvSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit isAddedToWatchlist false when not in watchlist',
      build: () {
        when(mockGetTvSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(isAddedToWatchlist: true),
      act: (b) => b.add(const LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        const TvSeriesDetailState(isAddedToWatchlist: false),
      ],
    );
  });

  group('AddTvSeriesWatchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and updated status when add is successful',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
            (_) async =>
                const Right(TvSeriesDetailBloc.watchlistAddSuccessMessage));
        when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const AddTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
            watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage),
        const TvSeriesDetailState(
            watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
            isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit error message when add fails',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure(message: 'Failed')));
        when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (b) => b.add(const AddTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Failed'),
      ],
    );
  });

  group('RemoveFromTvSeriesWatchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit success message and updated status when remove is successful',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right(
                TvSeriesDetailBloc.watchlistRemoveSuccessMessage));
        when(mockGetTvSeriesWatchlistStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const TvSeriesDetailState(isAddedToWatchlist: true),
      act: (b) =>
          b.add(const RemoveFromTvSeriesWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(
            watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
            isAddedToWatchlist: true),
        const TvSeriesDetailState(
            watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
            isAddedToWatchlist: false),
      ],
    );
  });
}
