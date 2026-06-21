import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  const TvSeries({
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
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final String? firstAirDate;
  final List<int>? genreIds;
  final String? originalName;

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
