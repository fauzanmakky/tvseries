part of 'watchlist_tv_series_bloc.dart';

class WatchlistTvSeriesState extends Equatable {
  final List<TvSeries> watchlistTvSeries;
  final RequestState watchlistState;
  final String message;

  const WatchlistTvSeriesState({
    this.watchlistTvSeries = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
  });

  WatchlistTvSeriesState copyWith({
    List<TvSeries>? watchlistTvSeries,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistTvSeriesState(
      watchlistTvSeries: watchlistTvSeries ?? this.watchlistTvSeries,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistTvSeries, watchlistState, message];
}
