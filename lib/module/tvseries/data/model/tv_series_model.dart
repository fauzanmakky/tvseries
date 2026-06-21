import 'package:equatable/equatable.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';

class TvSeriesModel extends Equatable {
  const TvSeriesModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.firstAirDate,
    required this.genreIds,
    required this.originalName,
  });

  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String? firstAirDate;
  final List<int> genreIds;
  final String? originalName;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'],
        popularity: (json['popularity'] as num).toDouble(),
        firstAirDate: json['first_air_date'],
        genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
        originalName: json['original_name'],
      );

  TvSeries toEntity() => TvSeries(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
        popularity: popularity,
        firstAirDate: firstAirDate,
        genreIds: genreIds,
        originalName: originalName,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        popularity,
        firstAirDate,
        genreIds,
        originalName,
      ];
}
