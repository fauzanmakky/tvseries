import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tvseries/module/movie/data/model/genre_model.dart';
import 'package:tvseries/module/movie/data/model/movie_detail_model.dart';
import 'package:tvseries/module/movie/data/model/movie_model.dart';
import 'package:tvseries/module/movie/data/repository/movie_repository_impl.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  const tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(ServerException());
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result, equals(Left(const ServerFailure(message: ''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result,
          equals(Left(const ConnectionFailure(message: 'Failed to connect to the network'))));
    });
  });

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getPopularMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(ServerException());
      final result = await repository.getPopularMovies();
      expect(result, Left(const ServerFailure(message: '')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularMovies();
      expect(
          result, Left(const ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getTopRatedMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedMovies();
      expect(result, Left(const ServerFailure(message: '')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedMovies();
      expect(
          result, Left(const ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('Get Movie Detail', () {
    const tId = 1;
    const tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Right(testMovieDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Left(const ServerFailure(message: ''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result,
          equals(Left(const ConnectionFailure(message: 'Failed to connect to the network'))));
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(Left(const ServerFailure(message: ''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result,
          equals(Left(const ConnectionFailure(message: 'Failed to connect to the network'))));
    });
  });

  group('Search Movies', () {
    const tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.searchMovies(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchMovies(tQuery);
      expect(result, Left(const ServerFailure(message: '')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchMovies(tQuery);
      expect(
          result, Left(const ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testMovieDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testMovieDetail);
      expect(result, Left(const DatabaseFailure(message: 'Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, Left(const DatabaseFailure(message: 'Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      final result = await repository.getWatchlistMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
