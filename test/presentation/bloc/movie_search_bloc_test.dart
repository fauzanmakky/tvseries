import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/search_movies_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  tearDown(() => bloc.close());

  const tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(bloc.state.state, RequestState.empty);
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (b) => b.add(const SearchMoviesEvent(tQuery)),
    expect: () => [
      const MovieSearchState(state: RequestState.loading),
      MovieSearchState(state: RequestState.loaded, searchResult: tMovieList),
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'should emit [loading, error] when data is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Failure')));
      return bloc;
    },
    act: (b) => b.add(const SearchMoviesEvent(tQuery)),
    expect: () => [
      const MovieSearchState(state: RequestState.loading),
      const MovieSearchState(
          state: RequestState.error, message: 'Server Failure'),
    ],
  );
}
