import 'package:ditonton_submission1/features/tv/data/models/genre_model.dart';
import 'package:home/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<dynamic> createdBy;
  final List<int> episodeRunTime;
  final DateTime firstAirDate;
  final List<GenreModel> genres;
  final String? homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final DateTime? lastAirDate;
  final String name;
  final dynamic nextEpisodeToAir;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<dynamic> productionCompanies;
  final String status;
  final String? tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        createdBy: List<dynamic>.from(json["created_by"]?.map((x) => x) ?? []),
        episodeRunTime: List<int>.from(
          json["episode_run_time"]?.map((x) => x) ?? [],
        ),
        firstAirDate:
            json["first_air_date"] != null
                ? DateTime.parse(json["first_air_date"])
                : DateTime.now(),
        genres: List<GenreModel>.from(
          json["genres"]?.map((x) => GenreModel.fromJson(x)) ?? [],
        ),
        homepage: json["homepage"],
        id: json["id"],
        inProduction: json["in_production"] ?? false,
        languages: List<String>.from(json["languages"]?.map((x) => x) ?? []),
        lastAirDate:
            json["last_air_date"] != null
                ? DateTime.parse(json["last_air_date"])
                : null,
        name: json["name"] ?? '',
        nextEpisodeToAir: json["next_episode_to_air"],
        numberOfEpisodes: json["number_of_episodes"] ?? 0,
        numberOfSeasons: json["number_of_seasons"] ?? 0,
        originCountry: List<String>.from(
          json["origin_country"]?.map((x) => x) ?? [],
        ),
        originalLanguage: json["original_language"] ?? '',
        originalName: json["original_name"] ?? '',
        overview: json["overview"] ?? '',
        popularity: (json["popularity"] ?? 0.0).toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: List<dynamic>.from(
          json["production_companies"]?.map((x) => x) ?? [],
        ),
        status: json["status"] ?? '',
        tagline: json["tagline"],
        type: json["type"] ?? '',
        voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
        voteCount: json["vote_count"] ?? 0,
      );

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath ?? '',
      id: id,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      name: name,
      overview: overview,
      posterPath: posterPath ?? '',
      voteAverage: voteAverage,
      voteCount: voteCount,
      firstAirDate: firstAirDate,
      genreIds: genres.map((genre) => genre.id).toList(),
      originalName: originalName,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      popularity: popularity,
      numberOfSeasons: numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
    );
  }

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    createdBy,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    lastAirDate,
    name,
    nextEpisodeToAir,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCompanies,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}
