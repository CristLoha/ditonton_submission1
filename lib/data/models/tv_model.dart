import 'package:equatable/equatable.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';

class TvModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final DateTime? firstAirDate;
  final List<int> genreIds;
  final String originalName;
  final List<String> originCountry;
  final String originalLanguage;
  final double popularity;
  final String? backdropPath;
  final bool adult;

  const TvModel({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    this.firstAirDate,
    required this.genreIds,
    required this.originalName,
    required this.originCountry,
    required this.originalLanguage,
    required this.popularity,
    this.backdropPath,
    required this.adult,
  });

  const TvModel.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  }) : adult = false,
       backdropPath = null,
       genreIds = const [],
       originCountry = const [],
       originalLanguage = '',
       originalName = '',
       voteAverage = 0.0,
       voteCount = 0,
       firstAirDate = null,
       popularity = 0.0;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    id: json["id"],
    name: json["name"] ?? '',
    overview: json["overview"] ?? '',
    posterPath:
        json["poster_path"] != null && json["poster_path"].toString().isNotEmpty
            ? json["poster_path"]
            : null,
    voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
    firstAirDate:
        json["first_air_date"] != null &&
                json["first_air_date"].toString().isNotEmpty
            ? DateTime.parse(json["first_air_date"])
            : null,
    genreIds: List<int>.from(json["genre_ids"]?.map((x) => x) ?? []),
    originalName: json["original_name"] ?? '',
    originCountry: List<String>.from(
      json["origin_country"]?.map((x) => x) ?? [],
    ),
    originalLanguage: json["original_language"] ?? '',
    popularity: (json["popularity"] ?? 0.0).toDouble(),
    backdropPath:
        json["backdrop_path"] != null &&
                json["backdrop_path"].toString().isNotEmpty
            ? json["backdrop_path"]
            : null,
    adult: json["adult"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "overview": overview,
    "poster_path": posterPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "first_air_date": firstAirDate?.toIso8601String(),
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "original_name": originalName,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "popularity": popularity,
    "backdrop_path": backdropPath,
    "adult": adult,
  };

  Tv toEntity() {
    return Tv(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath ?? '',
      voteAverage: voteAverage,
      voteCount: voteCount,
      firstAirDate: firstAirDate ?? DateTime.now(),
      genreIds: genreIds,
      originalName: originalName,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      popularity: popularity,
      backdropPath: backdropPath ?? '',
      adult: adult,
    );
  }

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
