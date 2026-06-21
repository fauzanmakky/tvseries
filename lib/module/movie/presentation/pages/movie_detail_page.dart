import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/genre_entity.dart';
import 'package:tvseries/module/movie/domain/entity/movie_detail_entity.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:tvseries/commons/constants/route_constants.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = '/detail';

  final int id;
  const MovieDetailPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieDetailBloc, MovieDetailState>(
      listenWhen: (previous, current) =>
          previous.watchlistMessage != current.watchlistMessage &&
          current.watchlistMessage.isNotEmpty,
      listener: (context, state) {
        final message = state.watchlistMessage;
        if (message == MovieDetailBloc.watchlistAddSuccessMessage ||
            message == MovieDetailBloc.watchlistRemoveSuccessMessage) {
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
        if (state.movieState == RequestState.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.movieState == RequestState.loaded &&
            state.movie != null) {
          return Scaffold(
            body: SafeArea(
              child: DetailContent(
                state.movie!,
                state.movieRecommendations,
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

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
      this.movie, this.recommendations, this.isAddedWatchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$kBaseImageUrl${movie.posterPath}',
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
                            Text(movie.title, style: kHeading5),
                            FilledButton(
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<MovieDetailBloc>()
                                      .add(AddWatchlist(movie));
                                } else {
                                  context
                                      .read<MovieDetailBloc>()
                                      .add(RemoveFromWatchlist(movie));
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
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<MovieDetailBloc, MovieDetailState>(
                              buildWhen: (p, c) =>
                                  p.recommendationState !=
                                      c.recommendationState ||
                                  p.movieRecommendations !=
                                      c.movieRecommendations,
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
                                      itemBuilder: (context, index) {
                                        final movie =
                                            recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () => context.pushReplacement(
                                              '${RouteConstants.movieDetail}/${movie.id}',
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$kBaseImageUrl${movie.posterPath}',
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
                                      itemCount: recommendations.length,
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}
