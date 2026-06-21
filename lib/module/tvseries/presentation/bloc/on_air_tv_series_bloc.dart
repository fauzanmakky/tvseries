import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart';

part 'on_air_tv_series_event.dart';
part 'on_air_tv_series_state.dart';

@injectable
class OnAirTvSeriesBloc extends Bloc<OnAirTvSeriesEvent, OnAirTvSeriesState> {
  final GetOnAirTvSeries getOnAirTvSeries;

  OnAirTvSeriesBloc(this.getOnAirTvSeries) : super(const OnAirTvSeriesState()) {
    on<FetchOnAirTvSeriesList>(_onFetch);
  }

  Future<void> _onFetch(
    FetchOnAirTvSeriesList event,
    Emitter<OnAirTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getOnAirTvSeries.execute();
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
