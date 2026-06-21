part of 'tv_series_detail_bloc.dart';

sealed class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;
  const FetchTvSeriesDetail(this.id);
  @override
  List<Object> get props => [id];
}

class LoadTvSeriesWatchlistStatus extends TvSeriesDetailEvent {
  final int id;
  const LoadTvSeriesWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}

class AddTvSeriesWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;
  const AddTvSeriesWatchlist(this.tvSeries);
  @override
  List<Object> get props => [tvSeries];
}

class RemoveFromTvSeriesWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;
  const RemoveFromTvSeriesWatchlist(this.tvSeries);
  @override
  List<Object> get props => [tvSeries];
}

class FetchTvSeriesSeasonDetail extends TvSeriesDetailEvent {
  final int tvId;
  final int seasonNumber;
  const FetchTvSeriesSeasonDetail(this.tvId, this.seasonNumber);
  @override
  List<Object> get props => [tvId, seasonNumber];
}
