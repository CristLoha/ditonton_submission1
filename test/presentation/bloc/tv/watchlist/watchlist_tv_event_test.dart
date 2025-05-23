import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/watchlist/watchlist_tv_bloc.dart';

void main() {
  group('WatchlistTvEvent', () {
    group('FetchWatchlistTvEvent', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = FetchWatchlistTvEvent();
        final secondEvent = FetchWatchlistTvEvent();

        // Act
        final comparisonResult = firstEvent == secondEvent;

        // Assert
        expect(comparisonResult, true);
      });

      test('props should be empty', () {
        // Arrange
        final event = FetchWatchlistTvEvent();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });

    group('Base WatchlistTvEvent', () {
      test('base event props should be empty', () {
        // Arrange
        final event = FetchWatchlistTvEvent() as WatchlistTvEvent;

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });
  });
}