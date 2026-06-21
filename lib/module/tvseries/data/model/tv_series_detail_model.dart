import 'package:equatable/equatable.dart';
import 'package:tvseries/module/movie/data/model/genre_model.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';

class TvSeriesDetailModel extends Equatable {
  const TvSeriesDetailModel({
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
  final List<GenreModel> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final double voteAverage;
  final int voteCount;
  final String firstAirDate;
  final String status;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailModel(
        id: json['id'],
        name: json['name'],
        originalName: json['original_name'],
        overview: json['overview'],
        posterPath: json['poster_path'] ?? '',
        backdropPath: json['backdrop_path'],
        genres: List<GenreModel>.from(
          (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
        ),
        numberOfEpisodes: json['number_of_episodes'] ?? 0,
        numberOfSeasons: json['number_of_seasons'] ?? 0,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'],
        firstAirDate: json['first_air_date'] ?? '',
        status: json['status'] ?? '',
      );

  TvSeriesDetail toEntity() => TvSeriesDetail(
        id: id,
        name: name,
        originalName: originalName,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        genres: genres.map((g) => g.toEntity()).toList(),
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        voteAverage: voteAverage,
        voteCount: voteCount,
        firstAirDate: firstAirDate,
        status: status,
      );

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
