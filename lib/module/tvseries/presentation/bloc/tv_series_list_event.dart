part of 'tv_series_list_bloc.dart';

sealed class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();
}

class FetchOnAirTvSeries extends TvSeriesListEvent {
  const FetchOnAirTvSeries();
  @override
  List<Object> get props => [];
}

class FetchTvSeriesListPopular extends TvSeriesListEvent {
  const FetchTvSeriesListPopular();
  @override
  List<Object> get props => [];
}

class FetchTvSeriesListTopRated extends TvSeriesListEvent {
  const FetchTvSeriesListTopRated();
  @override
  List<Object> get props => [];
}
