import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:tvseries/commons/error/exception.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_detail_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_response_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_season_model.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getOnAirTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<TvSeriesSeasonModel> getTvSeriesSeasonDetail(
      int tvId, int seasonNumber);
}

@LazySingleton(as: TvSeriesRemoteDataSource)
class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const _apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const _baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getOnAirTvSeries() async {
    final response =
        await client.get(Uri.parse('$_baseUrl/tv/on_the_air?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response =
        await client.get(Uri.parse('$_baseUrl/tv/popular?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response =
        await client.get(Uri.parse('$_baseUrl/tv/top_rated?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response =
        await client.get(Uri.parse('$_baseUrl/tv/$id?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$_baseUrl/tv/$id/recommendations?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client
        .get(Uri.parse('$_baseUrl/search/tv?$_apiKey&query=$query'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesSeasonModel> getTvSeriesSeasonDetail(
      int tvId, int seasonNumber) async {
    final response = await client.get(
        Uri.parse('$_baseUrl/tv/$tvId/season/$seasonNumber?$_apiKey'));
    if (response.statusCode == 200) {
      return TvSeriesSeasonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
