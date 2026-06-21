import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/constants/route_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatelessWidget {
  const HomeMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('Ditonton'),
              accountEmail: const Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () => context.pop(),
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () => context.push(RouteConstants.homeTvSeries),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () => context.push(RouteConstants.watchlist),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => context.push(RouteConstants.about),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteConstants.search),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (p, c) =>
                    p.nowPlayingState != c.nowPlayingState ||
                    p.nowPlayingMovies != c.nowPlayingMovies,
                builder: (context, state) {
                  if (state.nowPlayingState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.nowPlayingState == RequestState.loaded) {
                    return MovieList(state.nowPlayingMovies);
                  }
                  return const Text('Failed');
                },
              ),
              _buildSubHeading(
                context: context,
                title: 'Popular',
                onTap: () => context.push(RouteConstants.popularMovies),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (p, c) =>
                    p.popularMoviesState != c.popularMoviesState ||
                    p.popularMovies != c.popularMovies,
                builder: (context, state) {
                  if (state.popularMoviesState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.popularMoviesState == RequestState.loaded) {
                    return MovieList(state.popularMovies);
                  }
                  return const Text('Failed');
                },
              ),
              _buildSubHeading(
                context: context,
                title: 'Top Rated',
                onTap: () => context.push(RouteConstants.topRatedMovies),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                buildWhen: (p, c) =>
                    p.topRatedMoviesState != c.topRatedMoviesState ||
                    p.topRatedMovies != c.topRatedMovies,
                builder: (context, state) {
                  if (state.topRatedMoviesState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.topRatedMoviesState == RequestState.loaded) {
                    return MovieList(state.topRatedMovies);
                  }
                  return const Text('Failed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () =>
                  context.push('${RouteConstants.movieDetail}/${movie.id}'),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$kBaseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
