import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/search_movies_usecase.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

@injectable
class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
      : super(const MovieSearchState()) {
    on<SearchMoviesEvent>(_onSearchMovies);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.loading));
    final result = await searchMovies.execute(event.query);
    result.fold(
      (failure) => emit(state.copyWith(
        state: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        state: RequestState.loaded,
        searchResult: movies,
      )),
    );
  }
}
