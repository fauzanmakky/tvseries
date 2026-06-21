import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/commons/utils/utils.dart';
import 'package:tvseries/module/movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:tvseries/module/movie/presentation/widgets/movie_card_list.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/widgets/tv_series_card.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
    context
        .read<WatchlistTvSeriesBloc>()
        .add(const FetchWatchlistTvSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
    context
        .read<WatchlistTvSeriesBloc>()
        .add(const FetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.tv), text: 'TV Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                builder: (context, state) {
                  if (state.watchlistState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.watchlistState == RequestState.loaded) {
                    if (state.watchlistMovies.isEmpty) {
                      return const Center(child: Text('No movies in watchlist'));
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          MovieCard(state.watchlistMovies[index]),
                      itemCount: state.watchlistMovies.length,
                    );
                  }
                  return Center(
                    key: const Key('error_message'),
                    child: Text(state.message),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
                builder: (context, state) {
                  if (state.watchlistState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.watchlistState == RequestState.loaded) {
                    if (state.watchlistTvSeries.isEmpty) {
                      return const Center(
                          child: Text('No TV series in watchlist'));
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          TvSeriesCard(state.watchlistTvSeries[index]),
                      itemCount: state.watchlistTvSeries.length,
                    );
                  }
                  return Center(
                    key: const Key('error_message'),
                    child: Text(state.message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
