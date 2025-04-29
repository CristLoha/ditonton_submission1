import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final DateTime firstAirDate;
  final List<int> genreIds;
  final String originalName;
  final List<String> originCountry;
  final String originalLanguage;
  final double popularity;
  final String backdropPath;
  final bool adult;

  const TvDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.genreIds,
    required this.originalName,
    required this.originCountry,
    required this.originalLanguage,
    required this.popularity,
    required this.backdropPath,
    required this.adult,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    voteAverage,
    voteCount,
    firstAirDate,
    genreIds,
    originalName,
    originCountry,
    originalLanguage,
    popularity,
    backdropPath,
    adult,
  ];
}
