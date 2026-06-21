import 'package:tvseries/module/movie/data/datasource/db/database_helper.dart';
import 'package:tvseries/module/movie/data/datasource/local_datasource/movie_local_datasource.dart';
import 'package:tvseries/module/movie/data/datasource/remote_datasource/movie_remote_datasource.dart';
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart';
import 'package:tvseries/module/tvseries/data/datasource/local_datasource/tv_series_local_datasource.dart';
import 'package:tvseries/module/tvseries/data/datasource/remote_datasource/tv_series_remote_datasource.dart';
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  TvSeriesLocalDataSource,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
