import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

@injectable
class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(const PopularMoviesState()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await getPopularMovies.execute();
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
