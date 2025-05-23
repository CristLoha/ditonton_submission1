import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import '../../../../dummy_data/dummy_objects.dart';

void main() {
  group('TvDetailState', () {
    group('TvDetailHasData', () {
      test('copyWith should update specified fields', () {
        // Arrange
        final initial = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        // Act
        final updated = initial.copyWith(
          tv: testTvDetail,
          recommendations: [testTv, testTv],
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        );

        // Assert
        expect(updated.tv, testTvDetail);
        expect(updated.recommendations, [testTv, testTv]);
        expect(updated.isAddedToWatchlist, true);
        expect(updated.watchlistMessage, 'Added to Watchlist');
      });
      test('should handle null values in copyWith correctly', () {
        // Arrange
        final initial = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: 'Initial message',
        );

        // Act
        final updated = initial.copyWith(
          watchlistMessage: '',
        ); // Explicitly set empty message

        // Assert
        expect(updated.tv, initial.tv);
        expect(updated.recommendations, initial.recommendations);
        expect(updated.isAddedToWatchlist, false);
        expect(updated.watchlistMessage, '');
      });

      test('copyWith should maintain existing values when not specified', () {
        // Arrange
        final initial = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        // Act
        final updated = initial.copyWith(isAddedToWatchlist: true);

        // Assert
        expect(updated.tv, initial.tv);
        expect(updated.recommendations, initial.recommendations);
        expect(updated.isAddedToWatchlist, true);
        expect(updated.watchlistMessage, '');
      });

      test('supports value equality', () {
        // Arrange
        final state1 = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        final state2 = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        // Act
        final equalityResult = state1 == state2;

        // Assert
        expect(equalityResult, true);
      });

      test('props should contain all fields', () {
        // Arrange
        final state = TvDetailHasData(
          tv: testTvDetail,
          recommendations: [testTv],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        );

        // Act
        final props = state.props;

        // Assert
        expect(props, [
          testTvDetail,
          [testTv],
          false,
          '',
        ]);
      });
    });
  });
}
