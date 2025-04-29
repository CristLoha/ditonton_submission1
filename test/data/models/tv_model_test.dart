import 'package:ditonton_submission1/data/models/tv_model.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
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

  test('should be a subclass of Tv entity', () {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
