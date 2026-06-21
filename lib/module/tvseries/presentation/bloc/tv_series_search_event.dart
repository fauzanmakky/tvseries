part of 'tv_series_search_bloc.dart';

sealed class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();
}

class SearchTvSeriesEvent extends TvSeriesSearchEvent {
  final String query;
  const SearchTvSeriesEvent(this.query);
  @override
  List<Object> get props => [query];
}
