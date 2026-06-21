import 'package:equatable/equatable.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_episode_entity.dart';

class TvSeriesEpisodeModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? stillPath;
  final String airDate;
  final int episodeNumber;
  final int seasonNumber;
  final int runtime;
  final double voteAverage;

  const TvSeriesEpisodeModel({
    required this.id,
    required this.name,
    required this.overview,
    this.stillPath,
    required this.airDate,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.runtime,
    required this.voteAverage,
  });

  factory TvSeriesEpisodeModel.fromJson(Map<String, dynamic> json) =>
      TvSeriesEpisodeModel(
        id: json['id'],
        name: json['name'] ?? '',
        overview: json['overview'] ?? '',
        stillPath: json['still_path'],
        airDate: json['air_date'] ?? '',
        episodeNumber: json['episode_number'] ?? 0,
        seasonNumber: json['season_number'] ?? 0,
        runtime: json['runtime'] ?? 0,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      );

  TvSeriesEpisode toEntity() => TvSeriesEpisode(
        id: id,
        name: name,
        overview: overview,
        stillPath: stillPath,
        airDate: airDate,
        episodeNumber: episodeNumber,
        seasonNumber: seasonNumber,
        runtime: runtime,
        voteAverage: voteAverage,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        stillPath,
        airDate,
        episodeNumber,
        seasonNumber,
        runtime,
        voteAverage,
      ];
}
