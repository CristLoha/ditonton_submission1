import 'dart:convert';
import 'package:home/data/models/tv_model.dart';
import 'package:ditonton_submission1/features/tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    id: 1,
    name: 'Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
    firstAirDate: DateTime.parse('2020-05-05'),
    genreIds: [1, 2, 3, 4],
    originalName: 'Original Title',
    originCountry: ['US'],
    originalLanguage: 'en',
    popularity: 1.0,
    backdropPath: '/path.jpg',
    adult: false,
  );

  final tTvResponseModel = TvResponse(tvList: [tTvModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/on_the_air.json'),
      );
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      // arrange
      final expectedJsonMap = {
        "results": [
          {
            "id": 1,
            "name": "Title",
            "overview": "Overview",
            "poster_path": "/path.jpg",
            "vote_average": 1.0,
            "vote_count": 1,
            "first_air_date": "2020-05-05T00:00:00.000",
            "genre_ids": [1, 2, 3, 4],
            "original_name": "Original Title",
            "origin_country": ["US"],
            "original_language": "en",
            "popularity": 1.0,
            "backdrop_path": "/path.jpg",
            "adult": false,
          },
        ],
      };

      // act
      final result = tTvResponseModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
