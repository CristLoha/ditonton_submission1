import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

void main() {
  group('TopRatedMoviesEvent', () {
    group('FetchTopRatedMovies', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = FetchTopRatedMovies();
        final secondEvent = FetchTopRatedMovies();

        // Act
        final comparisonResult = firstEvent == secondEvent;

        // Assert
        expect(comparisonResult, true);
      });

      test('props should be empty', () {
        // Arrange
        final event = FetchTopRatedMovies();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });
  });
}