import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_event.dart';

void main() {
  group('WatchlistMovieEvent', () {
    group('FetchWatchlistMoviesEvent', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = FetchWatchlistMoviesEvent();
        final secondEvent = FetchWatchlistMoviesEvent();

        // Act
        final comparisonResult = firstEvent == secondEvent;

        // Assert
        expect(comparisonResult, true);
      });

      test('props should be empty', () {
        // Arrange
        final event = FetchWatchlistMoviesEvent();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });

    group('Base WatchlistMovieEvent', () {
      test('base props should be empty', () {
        // Arrange
        final event = FetchWatchlistMoviesEvent() as WatchlistMovieEvent;

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });
  });
}