part of 'on_air_tv_series_bloc.dart';

class OnAirTvSeriesState extends Equatable {
  final List<TvSeries> tvSeries;
  final RequestState state;
  final String message;

  const OnAirTvSeriesState({
    this.tvSeries = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  OnAirTvSeriesState copyWith({
    List<TvSeries>? tvSeries,
    RequestState? state,
    String? message,
  }) {
    return OnAirTvSeriesState(
      tvSeries: tvSeries ?? this.tvSeries,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvSeries, state, message];
}
