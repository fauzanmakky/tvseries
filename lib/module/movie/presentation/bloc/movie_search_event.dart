part of 'movie_search_bloc.dart';

sealed class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

class SearchMoviesEvent extends MovieSearchEvent {
  final String query;
  const SearchMoviesEvent(this.query);
  @override
  List<Object> get props => [query];
}
