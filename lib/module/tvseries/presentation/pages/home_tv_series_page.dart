import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/constants/route_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_list_bloc.dart';

class HomeTvSeriesPage extends StatelessWidget {
  const HomeTvSeriesPage({super.key});

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
              onTap: () => context.go(RouteConstants.home),
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () => context.pop(),
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
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteConstants.searchTvSeries),
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
              _buildSubHeading(
                context: context,
                title: 'On Air',
                onTap: () => context.push(RouteConstants.onAirTvSeries),
              ),
              BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                buildWhen: (p, c) =>
                    p.onAirState != c.onAirState ||
                    p.onAirTvSeries != c.onAirTvSeries,
                builder: (context, state) {
                  if (state.onAirState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.onAirState == RequestState.loaded) {
                    return TvSeriesHorizontalList(state.onAirTvSeries);
                  }
                  return const Text('Failed');
                },
              ),
              _buildSubHeading(
                context: context,
                title: 'Popular',
                onTap: () => context.push(RouteConstants.popularTvSeries),
              ),
              BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                buildWhen: (p, c) =>
                    p.popularState != c.popularState ||
                    p.popularTvSeries != c.popularTvSeries,
                builder: (context, state) {
                  if (state.popularState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.popularState == RequestState.loaded) {
                    return TvSeriesHorizontalList(state.popularTvSeries);
                  }
                  return const Text('Failed');
                },
              ),
              _buildSubHeading(
                context: context,
                title: 'Top Rated',
                onTap: () => context.push(RouteConstants.topRatedTvSeries),
              ),
              BlocBuilder<TvSeriesListBloc, TvSeriesListState>(
                buildWhen: (p, c) =>
                    p.topRatedState != c.topRatedState ||
                    p.topRatedTvSeries != c.topRatedTvSeries,
                builder: (context, state) {
                  if (state.topRatedState == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.topRatedState == RequestState.loaded) {
                    return TvSeriesHorizontalList(state.topRatedTvSeries);
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

class TvSeriesHorizontalList extends StatelessWidget {
  final List<TvSeries> tvSeriesList;

  const TvSeriesHorizontalList(this.tvSeriesList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeriesList.length,
        itemBuilder: (context, index) {
          final series = tvSeriesList[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => context
                  .push('${RouteConstants.tvSeriesDetail}/${series.id}'),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$kBaseImageUrl${series.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
