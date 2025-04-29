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

 const  Tv.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
    required this.firstAirDate,
  }) : voteAverage = 0,
       voteCount = 0,
       genreIds = const [],
       adult = false,
       backdropPath = '',
       originCountry = const [],
       originalLanguage = '',
       originalName = '',
       popularity = 0;

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

  factory Tv.fromJson(Map<String, dynamic> json) => Tv(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: List<int>.from(json["genre_ids"]?.map((x) => x) ?? []),
    id: json["id"],
    originCountry: List<String>.from(
      json["origin_country"]?.map((x) => x) ?? [],
    ),
    originalLanguage: json["original_language"] ?? '',
    originalName: json["original_name"] ?? '',
    overview: json["overview"] ?? '',
    popularity: (json["popularity"] ?? 0.0).toDouble(),
    posterPath: json["poster_path"] ?? '',
    firstAirDate:
        json["first_air_date"] != null
            ? DateTime.parse(json["first_air_date"])
            : null,
    name: json["name"] ?? '',
    voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
  );
}
