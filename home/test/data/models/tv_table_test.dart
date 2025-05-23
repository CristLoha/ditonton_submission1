import 'package:flutter_test/flutter_test.dart';
import 'package:home/data/models/tv_model.dart';
import 'package:home/data/models/tv_table.dart';
import 'package:home/domain/entities/genre.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/entities/tv_detail.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
  );

  final tTvTable2 = TvTable(
    id: 45789,
    name: 'Sturm der Liebe',
    overview:
        'These are the stories of relationships taking place in the fictional five-star hotel Fürstenhof, located in Feldkirchen-Westerham near Rosenheim with the plot revolving around members of the family room area, the hotel owners, and employees.',
    posterPath: '/jfFNydakwvbeACEwSd2Gh8UWtba.jpg',
  );

  final tTvDetail = TvDetail(
    genres: [Genre(id: 18, name: 'Drama')],
    numberOfSeasons: 1,
    numberOfEpisodes: 50,
    adult: false,
    backdropPath: '/h0y3OzHzG4yNvn8u3Za6ByH8lrQ.jpg',
    id: 45789,
    name: 'Sturm der Liebe',
    overview:
        'These are the stories of relationships taking place in the fictional five-star hotel Fürstenhof, located in Feldkirchen-Westerham near Rosenheim with the plot revolving around members of the family room area, the hotel owners, and employees.',
    posterPath: '/jfFNydakwvbeACEwSd2Gh8UWtba.jpg',
    voteAverage: 6.014,
    voteCount: 36,
    firstAirDate: DateTime.parse('2005-09-26'),
    genreIds: [18],
    originalName: 'Sturm der Liebe',
    originCountry: ['DE'],
    originalLanguage: 'de',
    popularity: 572.0316,
  );

  final tTvModel = TvModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: DateTime.parse('2023-01-15'),
    genreIds: [1],
    originalName: 'originalName',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    popularity: 1,
    backdropPath: 'backdropPath',
    adult: false,
  );

  final tTvMap = {
    'id': 1,
    'name': 'name',
    'overview': 'overview',
    'posterPath': 'posterPath',
  };

  group('TvTable', () {
    test('should create a TvTable from entity', () {
      // arrange
      final tvDetail = tTvDetail;

      // act
      final result = TvTable.fromEntity(tvDetail);

      // assert
      expect(result, tTvTable2);
    });

    test('should create a TvTable from map', () {
      // arrange
      final map = tTvMap;

      // act
      final result = TvTable.fromMap(map);

      // assert
      expect(result, tTvTable);
    });

    test('should create a TvTable from DTO', () {
      // arrange
      final tvModel = tTvModel;

      // act
      final result = TvTable.fromDT0(tvModel);

      // assert
      expect(result, tTvTable);
    });

    test('should convert to JSON', () {
      // act
      final result = tTvTable.toJson();

      // assert
      expect(result, tTvMap);
    });

    test('should convert to Entity', () {
      // act
      final result = tTvTable.toEntity();

      // assert
      final expectedTv = Tv.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: 'posterPath',
        name: 'name',
      );
      expect(result, expectedTv);
    });

    test('should handle null values from map', () {
      // arrange
      final Map<String, dynamic> map = {
        'id': 1,
        'name': null,
        'overview': null,
        'posterPath': null,
      };

      // act
      final result = TvTable.fromMap(map);

      // assert
      expect(result.name, '');
      expect(result.overview, '');
      expect(result.posterPath, '');
    });

    test('should support value equality', () {
      // arrange
      final table1 = tTvTable;
      final table2 = TvTable(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
      );

      // act & assert
      expect(table1, table2);
    });

    test('should have proper props', () {
      // act
      final props = tTvTable.props;

      // assert
      expect(props, [
        tTvTable.id,
        tTvTable.name,
        tTvTable.overview,
        tTvTable.posterPath,
      ]);
    });
  });
}
