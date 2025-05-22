import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

void main() {
  group('TopRatedMoviesEvent', () {
    group('FetchTopRatedMovies', () {
      test('supports value equality', () {
        expect(
          FetchTopRatedMovies(),
          equals(FetchTopRatedMovies()),
        );
      });

      test('props should be empty', () {

        final event = FetchTopRatedMovies();
        expect(event.props, []);
      });
    });
  });
}