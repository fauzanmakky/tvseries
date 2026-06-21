import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_movies_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  tearDown(() => bloc.close());

  test('initial state should be empty', () {
    expect(bloc.state.watchlistState, RequestState.empty);
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return bloc;
    },
    act: (b) => b.add(const FetchWatchlistMovies()),
    expect: () => [
      const WatchlistMovieState(watchlistState: RequestState.loading),
      WatchlistMovieState(
          watchlistState: RequestState.loaded,
          watchlistMovies: [testWatchlistMovie]),
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [loading, error] when data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure(message: "Can't get data")));
      return bloc;
    },
    act: (b) => b.add(const FetchWatchlistMovies()),
    expect: () => [
      const WatchlistMovieState(watchlistState: RequestState.loading),
      const WatchlistMovieState(
          watchlistState: RequestState.error, message: "Can't get data"),
    ],
  );
}
