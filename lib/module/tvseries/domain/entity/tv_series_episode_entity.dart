import 'package:equatable/equatable.dart';

class TvSeriesEpisode extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? stillPath;
  final String airDate;
  final int episodeNumber;
  final int seasonNumber;
  final int runtime;
  final double voteAverage;

  const TvSeriesEpisode({
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
