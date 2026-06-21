import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_top_rated_movies_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
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

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (b) => b.add(const FetchTopRatedMovies()),
    expect: () => [
      const TopRatedMoviesState(state: RequestState.loading),
      TopRatedMoviesState(state: RequestState.loaded, movies: tMovieList),
    ],
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [loading, error] when data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const FetchTopRatedMovies()),
    expect: () => [
      const TopRatedMoviesState(state: RequestState.loading),
      const TopRatedMoviesState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
