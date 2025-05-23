import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';

void main() {
  group('SearchMovieEvent', () {
    group('OnQueryChanged', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = OnQueryChanged('spiderman');
        const secondEvent = OnQueryChanged('spiderman');

        // Act
        final comparisonResult = firstEvent == secondEvent;

        // Assert
        expect(comparisonResult, true);
      });

      test('props should contain query', () {
        // Arrange
        const searchQuery = 'spiderman';
        final event = OnQueryChanged(searchQuery);

        // Act
        final props = event.props;

        // Assert
        expect(props, [searchQuery]);
      });
    });

    group('Base SearchMovieEvent', () {
      test('props should contain correct values', () {
        // Arrange
        final event = OnQueryChanged('') as SearchMovieEvent;

        // Act
        final props = event.props;

        // Assert
        expect(props, ['']);
      });
    });
  });
}