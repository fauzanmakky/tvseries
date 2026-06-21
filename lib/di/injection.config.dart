// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tvseries/di/register_module.dart' as _i456;
import 'package:tvseries/module/movie/data/datasource/db/database_helper.dart'
    as _i684;
import 'package:tvseries/module/movie/data/datasource/local_datasource/movie_local_datasource.dart'
    as _i443;
import 'package:tvseries/module/movie/data/datasource/remote_datasource/movie_remote_datasource.dart'
    as _i210;
import 'package:tvseries/module/movie/data/repository/movie_repository_impl.dart'
    as _i123;
import 'package:tvseries/module/movie/domain/repository/movie_repository.dart'
    as _i842;
import 'package:tvseries/module/movie/domain/usecase/get_movie_detail_usecase.dart'
    as _i327;
import 'package:tvseries/module/movie/domain/usecase/get_movie_recommendations_usecase.dart'
    as _i592;
import 'package:tvseries/module/movie/domain/usecase/get_now_playing_movies_usecase.dart'
    as _i718;
import 'package:tvseries/module/movie/domain/usecase/get_popular_movies_usecase.dart'
    as _i95;
import 'package:tvseries/module/movie/domain/usecase/get_top_rated_movies_usecase.dart'
    as _i413;
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_movies_usecase.dart'
    as _i1036;
import 'package:tvseries/module/movie/domain/usecase/get_watchlist_status_usecase.dart'
    as _i247;
import 'package:tvseries/module/movie/domain/usecase/remove_watchlist_usecase.dart'
    as _i993;
import 'package:tvseries/module/movie/domain/usecase/save_watchlist_usecase.dart'
    as _i847;
import 'package:tvseries/module/movie/domain/usecase/search_movies_usecase.dart'
    as _i966;
import 'package:tvseries/module/movie/presentation/bloc/movie_detail_bloc.dart'
    as _i522;
import 'package:tvseries/module/movie/presentation/bloc/movie_list_bloc.dart'
    as _i837;
import 'package:tvseries/module/movie/presentation/bloc/movie_search_bloc.dart'
    as _i780;
import 'package:tvseries/module/movie/presentation/bloc/popular_movies_bloc.dart'
    as _i627;
import 'package:tvseries/module/movie/presentation/bloc/top_rated_movies_bloc.dart'
    as _i540;
import 'package:tvseries/module/movie/presentation/bloc/watchlist_movie_bloc.dart'
    as _i327;
import 'package:tvseries/module/tvseries/data/datasource/local_datasource/tv_series_local_datasource.dart'
    as _i840;
import 'package:tvseries/module/tvseries/data/datasource/remote_datasource/tv_series_remote_datasource.dart'
    as _i742;
import 'package:tvseries/module/tvseries/data/repository/tv_series_repository_impl.dart'
    as _i693;
import 'package:tvseries/module/tvseries/domain/repository/tv_series_repository.dart'
    as _i171;
import 'package:tvseries/module/tvseries/domain/usecase/get_on_air_tv_series_usecase.dart'
    as _i698;
import 'package:tvseries/module/tvseries/domain/usecase/get_popular_tv_series_usecase.dart'
    as _i22;
import 'package:tvseries/module/tvseries/domain/usecase/get_top_rated_tv_series_usecase.dart'
    as _i311;
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_detail_usecase.dart'
    as _i240;
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_recommendations_usecase.dart'
    as _i434;
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_season_detail_usecase.dart'
    as _i313;
import 'package:tvseries/module/tvseries/domain/usecase/get_tv_series_watchlist_status_usecase.dart'
    as _i748;
import 'package:tvseries/module/tvseries/domain/usecase/get_watchlist_tv_series_usecase.dart'
    as _i388;
import 'package:tvseries/module/tvseries/domain/usecase/remove_tv_series_watchlist_usecase.dart'
    as _i527;
import 'package:tvseries/module/tvseries/domain/usecase/save_tv_series_watchlist_usecase.dart'
    as _i855;
import 'package:tvseries/module/tvseries/domain/usecase/search_tv_series_usecase.dart'
    as _i384;
import 'package:tvseries/module/tvseries/presentation/bloc/on_air_tv_series_bloc.dart'
    as _i440;
import 'package:tvseries/module/tvseries/presentation/bloc/popular_tv_series_bloc.dart'
    as _i729;
import 'package:tvseries/module/tvseries/presentation/bloc/top_rated_tv_series_bloc.dart'
    as _i209;
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_detail_bloc.dart'
    as _i11;
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_list_bloc.dart'
    as _i869;
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_search_bloc.dart'
    as _i129;
import 'package:tvseries/module/tvseries/presentation/bloc/watchlist_tv_series_bloc.dart'
    as _i961;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i519.Client>(
      () => registerModule.httpClient,
      preResolve: true,
    );
    gh.lazySingleton<_i684.DatabaseHelper>(() => _i684.DatabaseHelper());
    gh.lazySingleton<_i840.TvSeriesLocalDataSource>(
      () => _i840.TvSeriesLocalDataSourceImpl(
        databaseHelper: gh<_i684.DatabaseHelper>(),
      ),
    );
    gh.lazySingleton<_i443.MovieLocalDataSource>(
      () => _i443.MovieLocalDataSourceImpl(
        databaseHelper: gh<_i684.DatabaseHelper>(),
      ),
    );
    gh.lazySingleton<_i210.MovieRemoteDataSource>(
      () => _i210.MovieRemoteDataSourceImpl(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i742.TvSeriesRemoteDataSource>(
      () => _i742.TvSeriesRemoteDataSourceImpl(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i842.MovieRepository>(
      () => _i123.MovieRepositoryImpl(
        remoteDataSource: gh<_i210.MovieRemoteDataSource>(),
        localDataSource: gh<_i443.MovieLocalDataSource>(),
      ),
    );
    gh.factory<_i327.GetMovieDetail>(
      () => _i327.GetMovieDetail(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i592.GetMovieRecommendations>(
      () => _i592.GetMovieRecommendations(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i718.GetNowPlayingMovies>(
      () => _i718.GetNowPlayingMovies(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i95.GetPopularMovies>(
      () => _i95.GetPopularMovies(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i413.GetTopRatedMovies>(
      () => _i413.GetTopRatedMovies(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i247.GetWatchListStatus>(
      () => _i247.GetWatchListStatus(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i993.RemoveWatchlist>(
      () => _i993.RemoveWatchlist(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i847.SaveWatchlist>(
      () => _i847.SaveWatchlist(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i966.SearchMovies>(
      () => _i966.SearchMovies(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i780.MovieSearchBloc>(
      () => _i780.MovieSearchBloc(searchMovies: gh<_i966.SearchMovies>()),
    );
    gh.factory<_i522.MovieDetailBloc>(
      () => _i522.MovieDetailBloc(
        getMovieDetail: gh<_i327.GetMovieDetail>(),
        getMovieRecommendations: gh<_i592.GetMovieRecommendations>(),
        getWatchListStatus: gh<_i247.GetWatchListStatus>(),
        saveWatchlist: gh<_i847.SaveWatchlist>(),
        removeWatchlist: gh<_i993.RemoveWatchlist>(),
      ),
    );
    gh.lazySingleton<_i171.TvSeriesRepository>(
      () => _i693.TvSeriesRepositoryImpl(
        remoteDataSource: gh<_i742.TvSeriesRemoteDataSource>(),
        localDataSource: gh<_i840.TvSeriesLocalDataSource>(),
      ),
    );
    gh.factory<_i837.MovieListBloc>(
      () => _i837.MovieListBloc(
        getNowPlayingMovies: gh<_i718.GetNowPlayingMovies>(),
        getPopularMovies: gh<_i95.GetPopularMovies>(),
        getTopRatedMovies: gh<_i413.GetTopRatedMovies>(),
      ),
    );
    gh.factory<_i627.PopularMoviesBloc>(
      () => _i627.PopularMoviesBloc(gh<_i95.GetPopularMovies>()),
    );
    gh.factory<_i540.TopRatedMoviesBloc>(
      () => _i540.TopRatedMoviesBloc(
        getTopRatedMovies: gh<_i413.GetTopRatedMovies>(),
      ),
    );
    gh.factory<_i1036.GetWatchlistMovies>(
      () => _i1036.GetWatchlistMovies(gh<_i842.MovieRepository>()),
    );
    gh.factory<_i698.GetOnAirTvSeries>(
      () => _i698.GetOnAirTvSeries(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i22.GetPopularTvSeries>(
      () => _i22.GetPopularTvSeries(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i311.GetTopRatedTvSeries>(
      () => _i311.GetTopRatedTvSeries(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i240.GetTvSeriesDetail>(
      () => _i240.GetTvSeriesDetail(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i434.GetTvSeriesRecommendations>(
      () => _i434.GetTvSeriesRecommendations(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i313.GetTvSeriesSeasonDetail>(
      () => _i313.GetTvSeriesSeasonDetail(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i748.GetTvSeriesWatchlistStatus>(
      () => _i748.GetTvSeriesWatchlistStatus(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i388.GetWatchlistTvSeries>(
      () => _i388.GetWatchlistTvSeries(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i527.RemoveTvSeriesWatchlist>(
      () => _i527.RemoveTvSeriesWatchlist(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i855.SaveTvSeriesWatchlist>(
      () => _i855.SaveTvSeriesWatchlist(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i384.SearchTvSeries>(
      () => _i384.SearchTvSeries(gh<_i171.TvSeriesRepository>()),
    );
    gh.factory<_i440.OnAirTvSeriesBloc>(
      () => _i440.OnAirTvSeriesBloc(gh<_i698.GetOnAirTvSeries>()),
    );
    gh.factory<_i129.TvSeriesSearchBloc>(
      () =>
          _i129.TvSeriesSearchBloc(searchTvSeries: gh<_i384.SearchTvSeries>()),
    );
    gh.factory<_i209.TopRatedTvSeriesBloc>(
      () => _i209.TopRatedTvSeriesBloc(gh<_i311.GetTopRatedTvSeries>()),
    );
    gh.factory<_i327.WatchlistMovieBloc>(
      () => _i327.WatchlistMovieBloc(
        getWatchlistMovies: gh<_i1036.GetWatchlistMovies>(),
      ),
    );
    gh.factory<_i11.TvSeriesDetailBloc>(
      () => _i11.TvSeriesDetailBloc(
        getTvSeriesDetail: gh<_i240.GetTvSeriesDetail>(),
        getTvSeriesRecommendations: gh<_i434.GetTvSeriesRecommendations>(),
        getTvSeriesWatchlistStatus: gh<_i748.GetTvSeriesWatchlistStatus>(),
        saveTvSeriesWatchlist: gh<_i855.SaveTvSeriesWatchlist>(),
        removeTvSeriesWatchlist: gh<_i527.RemoveTvSeriesWatchlist>(),
        getTvSeriesSeasonDetail: gh<_i313.GetTvSeriesSeasonDetail>(),
      ),
    );
    gh.factory<_i869.TvSeriesListBloc>(
      () => _i869.TvSeriesListBloc(
        getOnAirTvSeries: gh<_i698.GetOnAirTvSeries>(),
        getPopularTvSeries: gh<_i22.GetPopularTvSeries>(),
        getTopRatedTvSeries: gh<_i311.GetTopRatedTvSeries>(),
      ),
    );
    gh.factory<_i729.PopularTvSeriesBloc>(
      () => _i729.PopularTvSeriesBloc(gh<_i22.GetPopularTvSeries>()),
    );
    gh.factory<_i961.WatchlistTvSeriesBloc>(
      () => _i961.WatchlistTvSeriesBloc(
        getWatchlistTvSeries: gh<_i388.GetWatchlistTvSeries>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i456.RegisterModule {}
