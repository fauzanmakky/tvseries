import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_now_playing_movies_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_top_rated_movies_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() => bloc.close());

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(bloc.state.nowPlayingState, RequestState.empty);
    expect(bloc.state.popularMoviesState, RequestState.empty);
    expect(bloc.state.topRatedMoviesState, RequestState.empty);
  });

  group('FetchNowPlayingMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when now playing data is successful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(const FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.loading),
        MovieListState(
            nowPlayingState: RequestState.loaded,
            nowPlayingMovies: tMovieList),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when now playing data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.loading),
        const MovieListState(
            nowPlayingState: RequestState.error, message: 'Server Failure'),
      ],
    );
  });

  group('FetchMovieListPopular', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when popular data is successful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieListPopular()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.loading),
        MovieListState(
            popularMoviesState: RequestState.loaded,
            popularMovies: tMovieList),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when popular data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieListPopular()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.loading),
        const MovieListState(
            popularMoviesState: RequestState.error, message: 'Server Failure'),
      ],
    );
  });

  group('FetchMovieListTopRated', () {
    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, loaded] when top rated data is successful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieListTopRated()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.loading),
        MovieListState(
            topRatedMoviesState: RequestState.loaded,
            topRatedMovies: tMovieList),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'should emit [loading, error] when top rated data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieListTopRated()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.loading),
        const MovieListState(
            topRatedMoviesState: RequestState.error,
            message: 'Server Failure'),
      ],
    );
  });
}
