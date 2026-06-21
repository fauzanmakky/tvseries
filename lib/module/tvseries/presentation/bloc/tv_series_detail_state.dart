part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> recommendations;
  final RequestState recommendationState;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;
  final TvSeriesSeason? seasonDetail;
  final RequestState seasonDetailState;
  final int selectedSeason;

  const TvSeriesDetailState({
    this.tvSeries,
    this.tvSeriesState = RequestState.empty,
    this.recommendations = const [],
    this.recommendationState = RequestState.empty,
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
    this.seasonDetail,
    this.seasonDetailState = RequestState.empty,
    this.selectedSeason = 1,
  });

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeries,
    RequestState? tvSeriesState,
    List<TvSeries>? recommendations,
    RequestState? recommendationState,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
    TvSeriesSeason? seasonDetail,
    RequestState? seasonDetailState,
    int? selectedSeason,
  }) {
    return TvSeriesDetailState(
      tvSeries: tvSeries ?? this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
      seasonDetail: seasonDetail ?? this.seasonDetail,
      seasonDetailState: seasonDetailState ?? this.seasonDetailState,
      selectedSeason: selectedSeason ?? this.selectedSeason,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        recommendations,
        recommendationState,
        isAddedToWatchlist,
        watchlistMessage,
        message,
        seasonDetail,
        seasonDetailState,
        selectedSeason,
      ];
}
