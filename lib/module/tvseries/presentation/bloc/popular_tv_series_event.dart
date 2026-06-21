part of 'popular_tv_series_bloc.dart';

sealed class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();
}

class FetchPopularTvSeries extends PopularTvSeriesEvent {
  const FetchPopularTvSeries();
  @override
  List<Object> get props => [];
}
