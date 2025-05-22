import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/popular/popular_movies_bloc.dart';

void main() {
  group('PopularMoviesEvent', () {
    test('FetchPopularMoviesData props should be empty', () {
      final event = FetchPopularMoviesData();

      expect(event.props, []);
    });

    test('supports value equality', () {
      expect(FetchPopularMoviesData(), equals(FetchPopularMoviesData()));
    });
  });
}
