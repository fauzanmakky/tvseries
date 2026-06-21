import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/usecase/get_popular_tv_series_usecase.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

@injectable
class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc(this.getPopularTvSeries)
      : super(const PopularTvSeriesState()) {
    on<FetchPopularTvSeries>(_onFetch);
  }

  Future<void> _onFetch(
    FetchPopularTvSeries event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getPopularTvSeries.execute();
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
