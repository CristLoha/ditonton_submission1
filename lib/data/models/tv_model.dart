import 'package:equatable/equatable.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';

class TvModel extends Equatable {
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

  const TvModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  const TvModel.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  }) : adult = false,
       backdropPath = null,
       genreIds = null,
       originCountry = null,
       originalLanguage = null,
       originalName = null,
       voteAverage = null,
       voteCount = null,
       firstAirDate = null,
       popularity = null;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds:
        json["genre_ids"] != null
            ? List<int>.from(json["genre_ids"].map((x) => x))
            : null,
    id: json["id"],
    originCountry:
        json["origin_country"] != null
            ? List<String>.from(json["origin_country"].map((x) => x))
            : null,
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"] ?? '',
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    firstAirDate:
        json["first_air_date"] != null
            ? DateTime.parse(json["first_air_date"])
            : null,
    name: json["name"] ?? '',
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids":
        genreIds != null ? List<dynamic>.from(genreIds!.map((x) => x)) : null,
    "id": id,
    "origin_country":
        originCountry != null
            ? List<dynamic>.from(originCountry!.map((x) => x))
            : null,
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "first_air_date":
        firstAirDate != null
            ? "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}"
            : null,
    "name": name,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

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

  Tv toEntity() {
    return Tv(
      adult: adult,
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      popularity: popularity,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
      overview: overview,
    );
  }
}
