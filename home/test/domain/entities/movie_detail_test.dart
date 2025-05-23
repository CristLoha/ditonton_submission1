import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/genre.dart';
import 'package:home/domain/entities/movie_detail.dart';

void main() {
  group('MovieDetail', () {
    final testMovieDetail = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [const Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: '2023-01-01',
      runtime: 120,
      title: 'title',
      voteAverage: 1.0,
      voteCount: 1,
    );

    test('should create MovieDetail object correctly', () {
      // assert
      expect(testMovieDetail.adult, false);
      expect(testMovieDetail.backdropPath, 'backdropPath');
      expect(testMovieDetail.genres.length, 1);
      expect(testMovieDetail.id, 1);
      expect(testMovieDetail.originalTitle, 'originalTitle');
      expect(testMovieDetail.overview, 'overview');
      expect(testMovieDetail.posterPath, 'posterPath');
      expect(testMovieDetail.releaseDate, '2023-01-01');
      expect(testMovieDetail.runtime, 120);
      expect(testMovieDetail.title, 'title');
      expect(testMovieDetail.voteAverage, 1.0);
      expect(testMovieDetail.voteCount, 1);
    });

    test('props should contain all properties', () {
      // act
      final props = testMovieDetail.props;

      // assert
      expect(props, [
        testMovieDetail.adult,
        testMovieDetail.backdropPath,
        testMovieDetail.genres,
        testMovieDetail.id,
        testMovieDetail.originalTitle,
        testMovieDetail.overview,
        testMovieDetail.posterPath,
        testMovieDetail.releaseDate,

        testMovieDetail.title,
        testMovieDetail.voteAverage,
        testMovieDetail.voteCount,
      ]);
    });
  });
}
