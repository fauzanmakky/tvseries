import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/commons/error/failure.dart';
import 'package:tvseries/module/movie/data/model/genre_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_detail_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_model.dart';
import 'package:tvseries/module/tvseries/data/repository/tv_series_repository_impl.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvSeriesModel = TvSeriesModel(
    id: 1,
    name: 'Stranger Things',
    overview: 'When a young boy vanishes, a small town uncovers a mystery.',
    posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
    backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
    voteAverage: 8.6,
    voteCount: 14000,
    popularity: 369.0,
    firstAirDate: '2016-07-15',
    genreIds: [18, 9648],
    originalName: 'Stranger Things',
  );

  const tTvSeries = TvSeries(
    id: 1,
    name: 'Stranger Things',
    overview: 'When a young boy vanishes, a small town uncovers a mystery.',
    posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
    backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
    voteAverage: 8.6,
    voteCount: 14000,
    popularity: 369.0,
    firstAirDate: '2016-07-15',
    genreIds: [18, 9648],
    originalName: 'Stranger Things',
  );

  final tTvSeriesModelList = [tTvSeriesModel];
  final tTvSeriesList = [tTvSeries];

  final tTvSeriesDetailModel = TvSeriesDetailModel(
    id: 1,
    name: 'Stranger Things',
    originalName: 'Stranger Things',
    overview: 'When a young boy vanishes, a small town uncovers a mystery.',
    posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
    backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
    genres: [const GenreModel(id: 18, name: 'Drama')],
    numberOfEpisodes: 34,
    numberOfSeasons: 4,
    voteAverage: 8.6,
    voteCount: 14000,
    firstAirDate: '2016-07-15',
    status: 'Ended',
  );

  group('getOnAirTvSeries', () {
    test('should return tv series list when remote call is successful',
        () async {
      when(mockRemoteDataSource.getOnAirTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getOnAirTvSeries();
      final resultList = result.getOrElse(() => []);

      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getOnAirTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getOnAirTvSeries();

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getOnAirTvSeries())
          .thenThrow(const SocketException('No internet'));

      final result = await repository.getOnAirTvSeries();

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('getPopularTvSeries', () {
    test('should return tv series list when remote call is successful',
        () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getPopularTvSeries();
      final resultList = result.getOrElse(() => []);

      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getPopularTvSeries();

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(const SocketException('No internet'));

      final result = await repository.getPopularTvSeries();

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('getTopRatedTvSeries', () {
    test('should return tv series list when remote call is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTopRatedTvSeries();
      final resultList = result.getOrElse(() => []);

      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getTopRatedTvSeries();

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(const SocketException('No internet'));

      final result = await repository.getTopRatedTvSeries();

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('getTvSeriesDetail', () {
    const tId = 1;

    test('should return tv series detail when remote call is successful',
        () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesDetailModel);

      final result = await repository.getTvSeriesDetail(tId);

      expect(result, Right(tTvSeriesDetailModel.toEntity()));
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());

      final result = await repository.getTvSeriesDetail(tId);

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(const SocketException('No internet'));

      final result = await repository.getTvSeriesDetail(tId);

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('getTvSeriesRecommendations', () {
    const tId = 1;

    test('should return list when remote call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTvSeriesRecommendations(tId);
      final resultList = result.getOrElse(() => []);

      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(ServerException());

      final result = await repository.getTvSeriesRecommendations(tId);

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(const SocketException('No internet'));

      final result = await repository.getTvSeriesRecommendations(tId);

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('searchTvSeries', () {
    const tQuery = 'Stranger Things';

    test('should return tv series list when remote call is successful',
        () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.searchTvSeries(tQuery);
      final resultList = result.getOrElse(() => []);

      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());

      final result = await repository.searchTvSeries(tQuery);

      expect(result, const Left(ServerFailure(message: '')));
    });

    test('should return ConnectionFailure on SocketException', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const SocketException('No internet'));

      final result = await repository.searchTvSeries(tQuery);

      expect(result,
          const Left(ConnectionFailure(message: 'Failed to connect to the network')));
    });
  });

  group('saveWatchlist', () {
    test('should return success message when insert is successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTvSeriesDetail);

      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to insert'));

      final result = await repository.saveWatchlist(testTvSeriesDetail);

      expect(result, const Left(DatabaseFailure(message: 'Failed to insert')));
    });
  });

  group('removeWatchlist', () {
    test('should return success message when remove is successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testTvSeriesDetail);

      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure on DatabaseException', () async {
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove'));

      final result = await repository.removeWatchlist(testTvSeriesDetail);

      expect(result, const Left(DatabaseFailure(message: 'Failed to remove')));
    });
  });

  group('isAddedToWatchlist', () {
    const tId = 1;

    test('should return true when tv series is in watchlist', () async {
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => testTvSeriesTable);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, true);
    });

    test('should return false when tv series is not in watchlist', () async {
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('getWatchlistTvSeries', () {
    test('should return watchlist tv series list from local data source',
        () async {
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);

      final result = await repository.getWatchlistTvSeries();
      final resultList = result.getOrElse(() => []);

      expect(resultList, [testTvSeriesTable.toEntity()]);
    });
  });
}
