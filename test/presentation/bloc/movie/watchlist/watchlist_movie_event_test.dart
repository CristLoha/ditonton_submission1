import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_event.dart';

void main() {
  group('WatchlistMovieEvent', () {
    group('FetchWatchlistMoviesEvent', () {
      test('supports value equality', () {
        expect(
          FetchWatchlistMoviesEvent(),
          equals(FetchWatchlistMoviesEvent()),
        );
      });

      test('props should be empty', () {
        final event = FetchWatchlistMoviesEvent();
        expect(event.props, []);
      });
    });

    group('Base WatchlistMovieEvent', () {
      test('base props should be empty', () {
        final event = FetchWatchlistMoviesEvent() as WatchlistMovieEvent;
        expect(event.props, []);
      });
    });
  });
}
