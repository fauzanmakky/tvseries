import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(mockGetPopularMovies);
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
    expect(bloc.state.state, RequestState.empty);
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (b) => b.add(const FetchPopularMovies()),
    expect: () => [
      const PopularMoviesState(state: RequestState.loading),
      PopularMoviesState(state: RequestState.loaded, movies: tMovieList),
    ],
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [loading, error] when data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const FetchPopularMovies()),
    expect: () => [
      const PopularMoviesState(state: RequestState.loading),
      const PopularMoviesState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
