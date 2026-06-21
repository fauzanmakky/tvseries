part of 'movie_list_bloc.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();
}

class FetchNowPlayingMovies extends MovieListEvent {
  const FetchNowPlayingMovies();
  @override
  List<Object> get props => [];
}

class FetchMovieListPopular extends MovieListEvent {
  const FetchMovieListPopular();
  @override
  List<Object> get props => [];
}

class FetchMovieListTopRated extends MovieListEvent {
  const FetchMovieListTopRated();
  @override
  List<Object> get props => [];
}
