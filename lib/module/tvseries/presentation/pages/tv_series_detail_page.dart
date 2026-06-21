import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/constants/route_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/genre_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_episode_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_detail_bloc.dart';

class TvSeriesDetailPage extends StatelessWidget {
  final int id;
  const TvSeriesDetailPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TvSeriesDetailBloc, TvSeriesDetailState>(
      listenWhen: (previous, current) =>
          previous.watchlistMessage != current.watchlistMessage &&
          current.watchlistMessage.isNotEmpty,
      listener: (context, state) {
        final message = state.watchlistMessage;
        if (message == TvSeriesDetailBloc.watchlistAddSuccessMessage ||
            message == TvSeriesDetailBloc.watchlistRemoveSuccessMessage) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(content: Text(message)),
          );
        }
      },
      builder: (context, state) {
        if (state.tvSeriesState == RequestState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.tvSeriesState == RequestState.loaded &&
            state.tvSeries != null) {
          return Scaffold(
            body: SafeArea(
              child: TvSeriesDetailContent(
                state.tvSeries!,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(child: Text(state.message)),
        );
      },
    );
  }
}

class TvSeriesDetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  const TvSeriesDetailContent(
      this.tvSeries, this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$kBaseImageUrl${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            FilledButton(
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvSeriesDetailBloc>()
                                      .add(AddTvSeriesWatchlist(tvSeries));
                                } else {
                                  context
                                      .read<TvSeriesDetailBloc>()
                                      .add(RemoveFromTvSeriesWatchlist(
                                          tvSeries));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Text(
                                '${tvSeries.numberOfSeasons} Season(s) · ${tvSeries.numberOfEpisodes} Episode(s)'),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text('Season & Episodes', style: kHeading6),
                            const SizedBox(height: 8),
                            _SeasonSelector(tvSeries: tvSeries),
                            const SizedBox(height: 8),
                            _EpisodeList(),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<TvSeriesDetailBloc,
                                TvSeriesDetailState>(
                              buildWhen: (p, c) =>
                                  p.recommendationState !=
                                      c.recommendationState ||
                                  p.recommendations != c.recommendations,
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state.recommendationState ==
                                    RequestState.error) {
                                  return Text(state.message);
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommendations.length,
                                      itemBuilder: (context, index) {
                                        final series = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () =>
                                                context.pushReplacement(
                                              '${RouteConstants.tvSeriesDetail}/${series.id}',
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$kBaseImageUrl${series.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) return result;
    return result.substring(0, result.length - 2);
  }
}

class _SeasonSelector extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  const _SeasonSelector({required this.tvSeries});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
      buildWhen: (p, c) => p.selectedSeason != c.selectedSeason,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tvSeries.numberOfSeasons, (index) {
              final seasonNum = index + 1;
              final isSelected = state.selectedSeason == seasonNum;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('Season $seasonNum'),
                  selected: isSelected,
                  onSelected: (_) => context.read<TvSeriesDetailBloc>().add(
                        FetchTvSeriesSeasonDetail(tvSeries.id, seasonNum),
                      ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _EpisodeList extends StatelessWidget {
  const _EpisodeList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
      buildWhen: (p, c) =>
          p.seasonDetailState != c.seasonDetailState ||
          p.seasonDetail != c.seasonDetail,
      builder: (context, state) {
        if (state.seasonDetailState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.seasonDetailState == RequestState.loaded &&
            state.seasonDetail != null) {
          final episodes = state.seasonDetail!.episodes;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: episodes.length,
            itemBuilder: (context, index) =>
                _EpisodeCard(episodes[index]),
          );
        } else if (state.seasonDetailState == RequestState.error) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  final TvSeriesEpisode episode;
  const _EpisodeCard(this.episode);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: episode.stillPath != null
                  ? CachedNetworkImage(
                      imageUrl: '$kBaseImageUrl${episode.stillPath}',
                      width: 100,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 70,
                        color: Colors.grey.shade800,
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 70,
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 70,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.tv),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ep ${episode.episodeNumber} · ${episode.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (episode.airDate.isNotEmpty)
                    Text(
                      episode.airDate,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400),
                    ),
                  if (episode.runtime > 0)
                    Text(
                      '${episode.runtime} min',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400),
                    ),
                  if (episode.overview.isNotEmpty)
                    Text(
                      episode.overview,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
