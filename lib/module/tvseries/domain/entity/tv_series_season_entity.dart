import 'package:equatable/equatable.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_episode_entity.dart';

class TvSeriesSeason extends Equatable {
  final int id;
  final String name;
  final String? airDate;
  final int seasonNumber;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final List<TvSeriesEpisode> episodes;

  const TvSeriesSeason({
    required this.id,
    required this.name,
    this.airDate,
    required this.seasonNumber,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        airDate,
        seasonNumber,
        overview,
        posterPath,
        voteAverage,
        episodes,
      ];
}
