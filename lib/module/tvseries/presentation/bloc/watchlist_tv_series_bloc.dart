import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_watchlist_tv_series_usecase.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

@injectable
class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
      : super(const WatchlistTvSeriesState()) {
    on<FetchWatchlistTvSeries>(_onFetch);
  }

  Future<void> _onFetch(
    FetchWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(state.copyWith(watchlistState: RequestState.loading));
    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        watchlistState: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        watchlistState: RequestState.loaded,
        watchlistTvSeries: series,
      )),
    );
  }
}
