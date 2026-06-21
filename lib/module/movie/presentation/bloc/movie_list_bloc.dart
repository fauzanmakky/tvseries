import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_now_playing_movies_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_top_rated_movies_usecase.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

@injectable
class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlayingMovies);
    on<FetchMovieListPopular>(_onFetchPopularMovies);
    on<FetchMovieListTopRated>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: RequestState.loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        nowPlayingState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        nowPlayingState: RequestState.loaded,
        nowPlayingMovies: movies,
      )),
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchMovieListPopular event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(popularMoviesState: RequestState.loading));
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        popularMoviesState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        popularMoviesState: RequestState.loaded,
        popularMovies: movies,
      )),
    );
  }

  Future<void> _onFetchTopRatedMovies(
    FetchMovieListTopRated event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(topRatedMoviesState: RequestState.loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        topRatedMoviesState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        topRatedMoviesState: RequestState.loaded,
        topRatedMovies: movies,
      )),
    );
  }
}
