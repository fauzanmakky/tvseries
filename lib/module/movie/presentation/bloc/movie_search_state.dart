part of 'movie_search_bloc.dart';

class MovieSearchState extends Equatable {
  final List<Movie> searchResult;
  final RequestState state;
  final String message;

  const MovieSearchState({
    this.searchResult = const [],
    this.state = RequestState.empty,
    this.message = '',
  });

  MovieSearchState copyWith({
    List<Movie>? searchResult,
    RequestState? state,
    String? message,
  }) {
    return MovieSearchState(
      searchResult: searchResult ?? this.searchResult,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [searchResult, state, message];
}
