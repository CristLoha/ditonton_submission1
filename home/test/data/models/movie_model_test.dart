import 'package:home/data/models/movie_model.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieJson = {
    "adult": false,
    "backdrop_path": "backdropPath",
    "genre_ids": [1, 2, 3],
    "id": 1,
    "original_title": "originalTitle",
    "overview": "overview",
    "popularity": 1.0,
    "poster_path": "posterPath",
    "release_date": "releaseDate",
    "title": "title",
    "video": false,
    "vote_average": 1.0,
    "vote_count": 1,
  };

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });

  group('MovieModel', () {
    test('should be a subclass of Movie entity', () {
      final result = tMovieModel.toEntity();
      expect(result, tMovie);
    });

    test('should create MovieModel from JSON', () {
      final Map<String, dynamic> jsonMap = tMovieJson;

      final result = MovieModel.fromJson(jsonMap);

      expect(result, tMovieModel);
    });

    test('should convert to JSON', () {
      final result = tMovieModel.toJson();

      expect(result, tMovieJson);
    });

    test('should have proper props', () {
      final props = tMovieModel.props;

      expect(props, [
        tMovieModel.adult,
        tMovieModel.backdropPath,
        tMovieModel.genreIds,
        tMovieModel.id,
        tMovieModel.originalTitle,
        tMovieModel.overview,
        tMovieModel.popularity,
        tMovieModel.posterPath,
        tMovieModel.releaseDate,
        tMovieModel.title,
        tMovieModel.video,
        tMovieModel.voteAverage,
        tMovieModel.voteCount,
      ]);
    });

    test('should support value equality', () {
      final movieModel1 = tMovieModel;
      final movieModel2 = MovieModel(
        adult: false,
        backdropPath: 'backdropPath',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'originalTitle',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        releaseDate: 'releaseDate',
        title: 'title',
        video: false,
        voteAverage: 1,
        voteCount: 1,
      );

      expect(movieModel1, movieModel2);
    });
  });
}
