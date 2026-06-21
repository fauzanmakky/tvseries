part of 'watchlist_movie_bloc.dart';

sealed class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();
}

class FetchWatchlistMovies extends WatchlistMovieEvent {
  const FetchWatchlistMovies();
  @override
  List<Object> get props => [];
}
