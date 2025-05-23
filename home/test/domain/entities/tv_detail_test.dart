import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/genre.dart';
import 'package:home/domain/entities/tv_detail.dart';

void main() {
  group('TvDetail', () {
    final testTvDetail = TvDetail(
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      voteAverage: 1.0,
      voteCount: 1,
      firstAirDate: DateTime(2023, 1, 1),
      genreIds: [1],
      genres: [const Genre(id: 1, name: 'Action')],
      originalName: 'originalName',
      originCountry: ['US'],
      originalLanguage: 'en',
      popularity: 1.0,
      backdropPath: 'backdropPath',
      adult: false,
      numberOfSeasons: 1,
      numberOfEpisodes: 10,
    );

    test('should create TvDetail object correctly', () {
      // assert
      expect(testTvDetail.id, 1);
      expect(testTvDetail.name, 'name');
      expect(testTvDetail.overview, 'overview');
      expect(testTvDetail.posterPath, 'posterPath');
      expect(testTvDetail.voteAverage, 1.0);
      expect(testTvDetail.voteCount, 1);
      expect(testTvDetail.firstAirDate, DateTime(2023, 1, 1));
      expect(testTvDetail.genreIds, [1]);
      expect(testTvDetail.genres.length, 1);
      expect(testTvDetail.originalName, 'originalName');
      expect(testTvDetail.originCountry, ['US']);
      expect(testTvDetail.originalLanguage, 'en');
      expect(testTvDetail.popularity, 1.0);
      expect(testTvDetail.backdropPath, 'backdropPath');
      expect(testTvDetail.adult, false);
      expect(testTvDetail.numberOfSeasons, 1);
      expect(testTvDetail.numberOfEpisodes, 10);
    });

    test('props should contain all properties', () {
      // act
      final props = testTvDetail.props;

      // assert
      expect(props, [
        testTvDetail.id,
        testTvDetail.name,
        testTvDetail.overview,
        testTvDetail.posterPath,
        testTvDetail.voteAverage,
        testTvDetail.voteCount,
        testTvDetail.firstAirDate,
        testTvDetail.genreIds,
        testTvDetail.genres,
        testTvDetail.originalName,
        testTvDetail.originCountry,
        testTvDetail.originalLanguage,
        testTvDetail.popularity,
        testTvDetail.backdropPath,
        testTvDetail.adult,
        testTvDetail.numberOfSeasons,
        testTvDetail.numberOfEpisodes,
      ]);
    });
  });
}