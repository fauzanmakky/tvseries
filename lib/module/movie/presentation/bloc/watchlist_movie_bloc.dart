import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_movies_usecase.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

@injectable
class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
      : super(const WatchlistMovieState()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMovies);
  }

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(state.copyWith(watchlistState: RequestState.loading));
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(state.copyWith(
        watchlistState: RequestState.error,
        message: failure.message,
      )),
      (movies) => emit(state.copyWith(
        watchlistState: RequestState.loaded,
        watchlistMovies: movies,
      )),
    );
  }
}
