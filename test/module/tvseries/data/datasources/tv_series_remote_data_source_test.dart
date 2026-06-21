import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/module/tvseries/data/datasource/remote_datasource/tv_series_remote_datasource.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_detail_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_response_model.dart';

import '../../../../helpers/test_helper.mocks.dart';
import '../../../../json_reader.dart';

void main() {
  const kApiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const kBaseUrl = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On Air Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_air.json')))
        .tvSeriesList;

    test('should return list of TvSeriesModel when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/on_the_air?$kApiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_air.json'), 200));
      final result = await dataSource.getOnAirTvSeries();
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/on_the_air?$kApiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getOnAirTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_popular.json')))
        .tvSeriesList;

    test('should return list of TvSeriesModel when response is success (200)',
        () async {
      when(mockHttpClient.get(Uri.parse('$kBaseUrl/tv/popular?$kApiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));
      final result = await dataSource.getPopularTvSeries();
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$kBaseUrl/tv/popular?$kApiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getPopularTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvSeriesList;

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/top_rated?$kApiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200));
      final result = await dataSource.getTopRatedTvSeries();
      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/top_rated?$kApiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTopRatedTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Series Detail', () {
    const tId = 1;
    final tTvSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return TvSeriesDetailModel when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$kBaseUrl/tv/$tId?$kApiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));
      final result = await dataSource.getTvSeriesDetail(tId);
      expect(result, equals(tTvSeriesDetail));
    });

    test(
        'should throw ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$kBaseUrl/tv/$tId?$kApiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvSeriesDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Series Recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvSeriesList;
    const tId = 1;

    test('should return list of TvSeriesModel when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/$tId/recommendations?$kApiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));
      final result = await dataSource.getTvSeriesRecommendations(tId);
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should throw ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/tv/$tId/recommendations?$kApiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvSeriesRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search Tv Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(json.decode(
            readJson('dummy_data/search_tv_stranger_things.json')))
        .tvSeriesList;
    const tQuery = 'Stranger Things';

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/search/tv?$kApiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_tv_stranger_things.json'), 200));
      final result = await dataSource.searchTvSeries(tQuery);
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$kBaseUrl/search/tv?$kApiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchTvSeries(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
