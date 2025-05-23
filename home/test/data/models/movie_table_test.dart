import 'package:flutter_test/flutter_test.dart';
import 'package:home/data/models/movie_table.dart';
import 'package:home/data/models/movie_model.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/entities/movie_detail.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  group('MovieTable', () {
    test('should create a MovieTable from entity', () {
      final movieDetail = tMovieDetail;

      final result = MovieTable.fromEntity(movieDetail);

      expect(result, tMovieTable);
    });

    test('should create a MovieTable from map', () {
      final map = tMovieMap;

      final result = MovieTable.fromMap(map);

      expect(result, tMovieTable);
    });

    test('should create a MovieTable from DTO', () {
      final movieModel = tMovieModel;

      final result = MovieTable.fromDT0(movieModel);

      expect(result, tMovieTable);
    });

    test('should convert to JSON', () {
      final result = tMovieTable.toJson();

      expect(result, tMovieMap);
    });

    test('should convert to Entity', () {
      final result = tMovieTable.toEntity();

      final expectedMovie = Movie.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: 'posterPath',
        title: 'title',
      );
      expect(result, expectedMovie);
    });

    test('should support value equality', () {
      final table1 = tMovieTable;
      final table2 = MovieTable(
        id: 1,
        title: 'title',
        posterPath: 'posterPath',
        overview: 'overview',
      );

      expect(table1, table2);
    });

    test('should have proper props', () {
      final props = tMovieTable.props;

      expect(props, [
        tMovieTable.id,
        tMovieTable.title,
        tMovieTable.posterPath,
        tMovieTable.overview,
      ]);
    });
  });
}
