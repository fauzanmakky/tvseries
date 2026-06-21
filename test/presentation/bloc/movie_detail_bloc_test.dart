import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/usecase/get_movie_detail_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_movie_recommendations_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_status_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/remove_watchlist_usecase.dart';
import 'package:tvseries/module/movie/domain/usecase/save_watchlist_usecase.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  tearDown(() => bloc.close());

  const tId = 1;
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
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit loading then loaded states when data is fetched successfully',
      build: () {
        arrangeUsecase();
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loading,
        ),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: tMovies,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit error when movie detail fetch fails',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        const MovieDetailState(
            movieState: RequestState.error, message: 'Server Failure'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit recommendation error when recommendation fetch fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure(message: 'Failed')));
        return bloc;
      },
      act: (b) => b.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loading,
        ),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit isAddedToWatchlist true when status is true',
      build: () {
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const MovieDetailState(isAddedToWatchlist: true),
      ],
    );
  });

  group('AddWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit watchlistMessage and update status when add is successful',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async =>
                const Right(MovieDetailBloc.watchlistAddSuccessMessage));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (b) => b.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
            watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage),
        const MovieDetailState(
            watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
            isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit watchlistMessage with error when add fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure(message: 'Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (b) => b.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(watchlistMessage: 'Failed'),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit watchlistMessage and update status when remove is successful',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async =>
                const Right(MovieDetailBloc.watchlistRemoveSuccessMessage));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => const MovieDetailState(isAddedToWatchlist: true),
      act: (b) => b.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
            watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
            isAddedToWatchlist: true),
        const MovieDetailState(
            watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
            isAddedToWatchlist: false),
      ],
    );
  });
}
