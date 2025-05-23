import 'package:home/data/models/tv_model.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: DateTime.parse('2023-01-15'),
    genreIds: [1, 2, 3],
    originalName: 'originalName',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    popularity: 1,
    backdropPath: 'backdropPath',
    adult: false,
  );

  final tTv = Tv(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: DateTime.parse('2023-01-15'),
    genreIds: [1, 2, 3],
    originalName: 'originalName',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    popularity: 1,
    backdropPath: 'backdropPath',
    adult: false,
  );

  final tTvWatchlist = const TvModel.watchlist(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    name: 'name',
  );

  final tTvJson = {
    'id': 1,
    'name': 'name',
    'overview': 'overview',
    'poster_path': 'posterPath',
    'vote_average': 1.0,
    'vote_count': 1,
    'first_air_date': '2023-01-15T00:00:00.000',
    'genre_ids': [1, 2, 3],
    'original_name': 'originalName',
    'origin_country': ['US'],
    'original_language': 'originalLanguage',
    'popularity': 1.0,
    'backdrop_path': 'backdropPath',
    'adult': false,
  };

  test('should be a subclass of Tv entity', () {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  group('TvModel', () {
    test('should be a subclass of Tv entity', () {
      final result = tTvModel.toEntity();

      expect(result, isA<Tv>());
    });

    test('should create TvModel from JSON', () {
      final Map<String, dynamic> jsonMap = tTvJson;

      final result = TvModel.fromJson(jsonMap);

      expect(result, tTvModel);
    });

    test('should create TvModel.watchlist properly', () {
      final result = const TvModel.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: 'posterPath',
        name: 'name',
      );

      expect(result, tTvWatchlist);
      expect(result.adult, false);
      expect(result.backdropPath, null);
      expect(result.genreIds, []);
      expect(result.originCountry, []);
      expect(result.originalLanguage, '');
      expect(result.originalName, '');
      expect(result.voteAverage, 0.0);
      expect(result.voteCount, 0);
      expect(result.firstAirDate, null);
      expect(result.popularity, 0.0);
    });

    test('should convert to JSON', () {
      final expectedJson = tTvJson;

      final result = tTvModel.toJson();

      expect(result, expectedJson);
    });

    test('should handle null values from JSON', () {
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "name": null,
        "overview": null,
        "poster_path": null,
        "vote_average": null,
        "vote_count": null,
        "first_air_date": null,
        "genre_ids": null,
        "original_name": null,
        "origin_country": null,
        "original_language": null,
        "popularity": null,
        "backdrop_path": null,
        "adult": null,
      };

      final result = TvModel.fromJson(jsonMap);

      expect(result.name, '');
      expect(result.overview, '');
      expect(result.posterPath, null);
      expect(result.voteAverage, 0.0);
      expect(result.voteCount, 0);
      expect(result.firstAirDate, null);
      expect(result.genreIds, []);
      expect(result.originalName, '');
      expect(result.originCountry, []);
      expect(result.originalLanguage, '');
      expect(result.popularity, 0.0);
      expect(result.backdropPath, null);
      expect(result.adult, false);
    });

    test('should have proper props', () {
      final props = tTvModel.props;

      expect(props, [
        tTvModel.id,
        tTvModel.name,
        tTvModel.overview,
        tTvModel.posterPath,
        tTvModel.voteAverage,
        tTvModel.voteCount,
        tTvModel.firstAirDate,
        tTvModel.genreIds,
        tTvModel.originalName,
        tTvModel.originCountry,
        tTvModel.originalLanguage,
        tTvModel.popularity,
        tTvModel.backdropPath,
        tTvModel.adult,
      ]);
    });
  });
}
