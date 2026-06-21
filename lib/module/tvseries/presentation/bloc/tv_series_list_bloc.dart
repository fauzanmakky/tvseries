import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_popular_tv_series_usecase.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_top_rated_tv_series_usecase.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

@injectable
class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetOnAirTvSeries getOnAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvSeriesListBloc({
    required this.getOnAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvSeriesListState()) {
    on<FetchOnAirTvSeries>(_onFetchOnAir);
    on<FetchTvSeriesListPopular>(_onFetchPopular);
    on<FetchTvSeriesListTopRated>(_onFetchTopRated);
  }

  Future<void> _onFetchOnAir(
    FetchOnAirTvSeries event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(onAirState: RequestState.loading));
    final result = await getOnAirTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        onAirState: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        onAirState: RequestState.loaded,
        onAirTvSeries: series,
      )),
    );
  }

  Future<void> _onFetchPopular(
    FetchTvSeriesListPopular event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(popularState: RequestState.loading));
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        popularState: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        popularState: RequestState.loaded,
        popularTvSeries: series,
      )),
    );
  }

  Future<void> _onFetchTopRated(
    FetchTvSeriesListTopRated event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(state.copyWith(topRatedState: RequestState.loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedState: RequestState.error,
        message: failure.message,
      )),
      (series) => emit(state.copyWith(
        topRatedState: RequestState.loaded,
        topRatedTvSeries: series,
      )),
    );
  }
}
