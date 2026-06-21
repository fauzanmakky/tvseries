import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_top_rated_movies_usecase.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

@injectable
class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies})
      : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMovies event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        state: RequestState.loaded,
        movies: movies,
      )),
    );
  }
}
