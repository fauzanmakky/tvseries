part of 'tv_series_list_bloc.dart';

class TvSeriesListState extends Equatable {
  final List<TvSeries> onAirTvSeries;
  final RequestState onAirState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedState;
  final String message;

  const TvSeriesListState({
    this.onAirTvSeries = const [],
    this.onAirState = RequestState.empty,
    this.popularTvSeries = const [],
    this.popularState = RequestState.empty,
    this.topRatedTvSeries = const [],
    this.topRatedState = RequestState.empty,
    this.message = '',
  });

  TvSeriesListState copyWith({
    List<TvSeries>? onAirTvSeries,
    RequestState? onAirState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedState,
    String? message,
  }) {
    return TvSeriesListState(
      onAirTvSeries: onAirTvSeries ?? this.onAirTvSeries,
      onAirState: onAirState ?? this.onAirState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularState: popularState ?? this.popularState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedState: topRatedState ?? this.topRatedState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        onAirTvSeries,
        onAirState,
        popularTvSeries,
        popularState,
        topRatedTvSeries,
        topRatedState,
        message,
      ];
}
