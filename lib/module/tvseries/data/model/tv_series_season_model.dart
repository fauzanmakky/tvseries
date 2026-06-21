import 'package:equatable/equatable.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_episode_model.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';

class TvSeriesSeasonModel extends Equatable {
  final int id;
  final String name;
  final String? airDate;
  final int seasonNumber;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final List<TvSeriesEpisodeModel> episodes;

  const TvSeriesSeasonModel({
    required this.id,
    required this.name,
    this.airDate,
    required this.seasonNumber,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.episodes,
  });

  factory TvSeriesSeasonModel.fromJson(Map<String, dynamic> json) =>
      TvSeriesSeasonModel(
        id: json['id'],
        name: json['name'] ?? '',
        airDate: json['air_date'],
        seasonNumber: json['season_number'] ?? 0,
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        episodes: (json['episodes'] as List? ?? [])
            .map((e) => TvSeriesEpisodeModel.fromJson(e))
            .toList(),
      );

  TvSeriesSeason toEntity() => TvSeriesSeason(
        id: id,
        name: name,
        airDate: airDate,
        seasonNumber: seasonNumber,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        episodes: episodes.map((e) => e.toEntity()).toList(),
      );

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
