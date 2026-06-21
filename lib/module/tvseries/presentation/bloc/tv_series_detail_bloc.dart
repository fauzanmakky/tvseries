import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_detail_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_recommendations_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_season_detail_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_watchlist_status_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/remove_tv_series_watchlist_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/save_tv_series_watchlist_usecase.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

@injectable
class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetTvSeriesWatchlistStatus getTvSeriesWatchlistStatus;
  final SaveTvSeriesWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;
  final GetTvSeriesSeasonDetail getTvSeriesSeasonDetail;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getTvSeriesWatchlistStatus,
    required this.saveTvSeriesWatchlist,
    required this.removeTvSeriesWatchlist,
    required this.getTvSeriesSeasonDetail,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<LoadTvSeriesWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddTvSeriesWatchlist>(_onAddWatchlist);
    on<RemoveFromTvSeriesWatchlist>(_onRemoveFromWatchlist);
    on<FetchTvSeriesSeasonDetail>(_onFetchSeasonDetail);
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesState: RequestState.loading));
    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) => emit(state.copyWith(
        tvSeriesState: RequestState.error,
        message: failure.message,
      )),
      (tvSeries) {
        emit(state.copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: tvSeries,
          recommendationState: RequestState.loading,
        ));
        recommendationResult.fold(
          (failure) => emit(state.copyWith(
            recommendationState: RequestState.error,
            message: failure.message,
          )),
          (series) => emit(state.copyWith(
            recommendationState: RequestState.loaded,
            recommendations: series,
          )),
        );
        if (tvSeries.numberOfSeasons > 0) {
          add(FetchTvSeriesSeasonDetail(tvSeries.id, 1));
        }
      },
    );
  }

  Future<void> _onFetchSeasonDetail(
    FetchTvSeriesSeasonDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(
      seasonDetailState: RequestState.loading,
      selectedSeason: event.seasonNumber,
    ));
    final result = await getTvSeriesSeasonDetail.execute(
        event.tvId, event.seasonNumber);
    result.fold(
      (failure) => emit(state.copyWith(
        seasonDetailState: RequestState.error,
        message: failure.message,
      )),
      (season) => emit(state.copyWith(
        seasonDetailState: RequestState.loaded,
        seasonDetail: season,
      )),
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getTvSeriesWatchlistStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddTvSeriesWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveTvSeriesWatchlist.execute(event.tvSeries);
    result.fold(
      (failure) =>
          emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadTvSeriesWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromTvSeriesWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeTvSeriesWatchlist.execute(event.tvSeries);
    result.fold(
      (failure) =>
          emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadTvSeriesWatchlistStatus(event.tvSeries.id));
  }
}
