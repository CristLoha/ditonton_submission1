import 'package:equatable/equatable.dart';

class Tv extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String overview;
  final double? popularity;
  final String? posterPath;
  final DateTime? firstAirDate;
  final String name;
  final double? voteAverage;
  final int? voteCount;

  const Tv({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.genreIds,
    required this.adult,
    required this.backdropPath,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.popularity,
  });

  const Tv.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  }) : voteAverage = null,
       voteCount = null,
       genreIds = null,
       adult = null,
       backdropPath = null,
       originCountry = null,
       originalLanguage = null,
       originalName = null,
       popularity = null,
       firstAirDate = null;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genreIds,
    id,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    name,
    voteAverage,
    voteCount,
  ];
}
