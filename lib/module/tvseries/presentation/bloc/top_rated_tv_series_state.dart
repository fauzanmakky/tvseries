part of 'top_rated_tv_series_bloc.dart';

class TopRatedTvSeriesState extends Equatable {
  final List<TvSeries> tvSeries;
  final RequestState state;
  final String message;

  const TopRatedTvSeriesState({
    this.tvSeries = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  TopRatedTvSeriesState copyWith({
    List<TvSeries>? tvSeries,
    RequestState? state,
    String? message,
  }) {
    return TopRatedTvSeriesState(
      tvSeries: tvSeries ?? this.tvSeries,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvSeries, state, message];
}
