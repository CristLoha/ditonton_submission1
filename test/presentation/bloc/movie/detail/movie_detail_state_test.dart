import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_state.dart';
import '../../../../dummy_data/dummy_objects.dart';

void main() {
  group('MovieDetailState', () {
    group('MovieDetailHasData', () {
      test('copyWith should update specified fields', () {
        final initial = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        final updated = initial.copyWith(
          movie: testMovieDetail,
          recommendations: [testMovie, testMovie],
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        );

        expect(updated.movie, testMovieDetail);
        expect(updated.recommendations, [testMovie, testMovie]);
        expect(updated.isAddedToWatchlist, true);
        expect(updated.watchlistMessage, 'Added to Watchlist');
      });
      test('should handle null values in copyWith correctly', () {
        final initial = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: 'Initial message',
        );

        final updated = initial.copyWith();

        expect(updated.isAddedToWatchlist, false);
        expect(updated.watchlistMessage, '');
      });

      test('copyWith should maintain existing values when not specified', () {
        final initial = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        final updated = initial.copyWith(isAddedToWatchlist: true);

        expect(updated.movie, initial.movie);
        expect(updated.recommendations, initial.recommendations);
        expect(updated.isAddedToWatchlist, true);
        expect(updated.watchlistMessage, '');
      });

      test('supports value equality', () {
        final state1 = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        final state2 = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        expect(state1, equals(state2));
      });

      test('props should contain all fields', () {
        final state = MovieDetailHasData(
          movie: testMovieDetail,
          recommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        expect(state.props, [
          testMovieDetail,
          [testMovie],
          false,
          '',
        ]);
      });
    });
  });
}
