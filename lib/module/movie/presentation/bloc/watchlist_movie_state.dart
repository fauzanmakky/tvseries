part of 'watchlist_movie_bloc.dart';

class WatchlistMovieState extends Equatable {
  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  const WatchlistMovieState({
    this.watchlistMovies = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
  });

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistMovies, watchlistState, message];
}
