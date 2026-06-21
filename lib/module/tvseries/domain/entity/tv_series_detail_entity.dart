import 'package:equatable/equatable.dart';
import 'package:tvseries/module/movie/domain/entity/genre_entity.dart';

class TvSeriesDetail extends Equatable {
  const TvSeriesDetail({
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.status,
  });

  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final List<Genre> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final String status;

  @override
  List<Object?> get props => [
        id,
        name,
        originalName,
        overview,
        posterPath,
        backdropPath,
        genres,
        numberOfEpisodes,
        numberOfSeasons,
        voteAverage,
        voteCount,
        firstAirDate,
        status,
      ];
}
