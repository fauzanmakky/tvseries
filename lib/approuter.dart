import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tvseries/commons/constants/route_constants.dart';
import 'package:tvseries/commons/utils/utils.dart';
import 'package:tvseries/di/injection.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_search_bloc.dart';
import 'package:tvseries/module/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:tvseries/module/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:tvseries/module/movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tvseries/module/movie/presentation/pages/about_page.dart';
import 'package:tvseries/module/movie/presentation/pages/home_movie_page.dart';
import 'package:tvseries/module/movie/presentation/pages/movie_detail_page.dart';
import 'package:tvseries/module/movie/presentation/pages/popular_movies_page.dart';
import 'package:tvseries/module/movie/presentation/pages/search_page.dart';
import 'package:tvseries/module/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tvseries/module/movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/on_air_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_list_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_search_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/home_tv_series_page.dart';
import 'package:tvseries/module/tvseries/presentation/pages/on_air_tv_series_page.dart';
import 'package:tvseries/module/tvseries/presentation/pages/popular_tv_series_page.dart';
import 'package:tvseries/module/tvseries/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tvseries/module/tvseries/presentation/pages/tv_series_detail_page.dart';
import 'package:tvseries/module/tvseries/presentation/pages/tv_series_search_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteConstants.home,
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MovieListBloc>()
            ..add(const FetchNowPlayingMovies())
            ..add(const FetchMovieListPopular())
            ..add(const FetchMovieListTopRated()),
          child: const HomeMoviePage(),
        ),
      ),
      GoRoute(
        path: '${RouteConstants.movieDetail}/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => getIt<MovieDetailBloc>()
              ..add(FetchMovieDetail(id))
              ..add(LoadWatchlistStatus(id)),
            child: MovieDetailPage(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.popularMovies,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<PopularMoviesBloc>()..add(const FetchPopularMovies()),
          child: const PopularMoviesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.topRatedMovies,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<TopRatedMoviesBloc>()..add(const FetchTopRatedMovies()),
          child: const TopRatedMoviesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.search,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<MovieSearchBloc>(),
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.watchlist,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<WatchlistMovieBloc>()),
            BlocProvider(create: (_) => getIt<WatchlistTvSeriesBloc>()),
          ],
          child: const WatchlistMoviesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: RouteConstants.homeTvSeries,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<TvSeriesListBloc>()
            ..add(const FetchOnAirTvSeries())
            ..add(const FetchTvSeriesListPopular())
            ..add(const FetchTvSeriesListTopRated()),
          child: const HomeTvSeriesPage(),
        ),
      ),
      GoRoute(
        path: '${RouteConstants.tvSeriesDetail}/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => getIt<TvSeriesDetailBloc>()
              ..add(FetchTvSeriesDetail(id))
              ..add(LoadTvSeriesWatchlistStatus(id)),
            child: TvSeriesDetailPage(id: id),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.onAirTvSeries,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<OnAirTvSeriesBloc>()..add(const FetchOnAirTvSeriesList()),
          child: const OnAirTvSeriesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.popularTvSeries,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<PopularTvSeriesBloc>()..add(const FetchPopularTvSeries()),
          child: const PopularTvSeriesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.topRatedTvSeries,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<TopRatedTvSeriesBloc>()..add(const FetchTopRatedTvSeries()),
          child: const TopRatedTvSeriesPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.searchTvSeries,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<TvSeriesSearchBloc>(),
          child: const TvSeriesSearchPage(),
        ),
      ),
    ],
  );
}
