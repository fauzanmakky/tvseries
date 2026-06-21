import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_detail_entity.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_movie_detail_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_movie_recommendations_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_status_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/remove_watchlist_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/save_watchlist_usecase.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

@injectable
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.loading));
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(event.id);
    detailResult.fold(
      (failure) => emit(state.copyWith(
        movieState: RequestState.error,
        message: failure.message,
      )),
      (movie) {
        emit(state.copyWith(
          movieState: RequestState.loaded,
          movie: movie,
          recommendationState: RequestState.loading,
        ));
        recommendationResult.fold(
          (failure) => emit(state.copyWith(
            recommendationState: RequestState.error,
            message: failure.message,
          )),
          (movies) => emit(state.copyWith(
            recommendationState: RequestState.loaded,
            movieRecommendations: movies,
          )),
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadWatchlistStatus(event.movie.id));
  }
}
