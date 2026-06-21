part of 'on_air_tv_series_bloc.dart';

sealed class OnAirTvSeriesEvent extends Equatable {
  const OnAirTvSeriesEvent();
}

class FetchOnAirTvSeriesList extends OnAirTvSeriesEvent {
  const FetchOnAirTvSeriesList();
  @override
  List<Object> get props => [];
}
