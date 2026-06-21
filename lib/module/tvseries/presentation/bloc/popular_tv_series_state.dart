part of 'popular_tv_series_bloc.dart';

class PopularTvSeriesState extends Equatable {
  final List<TvSeries> tvSeries;
  final RequestState state;
  final String message;

  const PopularTvSeriesState({
    this.tvSeries = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  PopularTvSeriesState copyWith({
    List<TvSeries>? tvSeries,
    RequestState? state,
    String? message,
  }) {
    return PopularTvSeriesState(
      tvSeries: tvSeries ?? this.tvSeries,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvSeries, state, message];
}
