import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_top_rated_tv_series_usecase.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

@injectable
class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this.getTopRatedTvSeries)
      : super(const TopRatedTvSeriesState()) {
    on<FetchTopRatedTvSeries>(_onFetch);
  }

  Future<void> _onFetch(
    FetchTopRatedTvSeries event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        state: RequestState.loaded,
        tvSeries: series,
      )),
    );
  }
}
