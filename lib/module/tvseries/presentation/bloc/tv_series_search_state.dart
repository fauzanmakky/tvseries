part of 'tv_series_search_bloc.dart';

class TvSeriesSearchState extends Equatable {
  final List<TvSeries> searchResult;
  final RequestState state;
  final String message;

  const TvSeriesSearchState({
    this.searchResult = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  TvSeriesSearchState copyWith({
    List<TvSeries>? searchResult,
    RequestState? state,
    String? message,
  }) {
    return TvSeriesSearchState(
      searchResult: searchResult ?? this.searchResult,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [searchResult, state, message];
}
