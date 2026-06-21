import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/search_tv_series_usecase.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

@injectable
class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc({required this.searchTvSeries})
      : super(const TvSeriesSearchState()) {
    on<SearchTvSeriesEvent>(_onSearch);
  }

  Future<void> _onSearch(
    SearchTvSeriesEvent event,
    Emitter<TvSeriesSearchState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await searchTvSeries.execute(event.query);
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        state: RequestState.loaded,
        searchResult: series,
      )),
    );
  }
}
