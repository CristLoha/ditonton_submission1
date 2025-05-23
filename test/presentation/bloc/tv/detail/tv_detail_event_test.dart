import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import '../../../../dummy_data/dummy_objects.dart';

void main() {
  group('TvDetailEvent', () {
    group('FetchTvDetail', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = FetchTvDetail(1);
        const secondEvent = FetchTvDetail(1);
        const differentEvent = FetchTvDetail(2);

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props contains id', () {
        // Arrange
        const tvId = 1;
        const event = FetchTvDetail(tvId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [tvId]);
      });
    });

    group('AddWatchlist', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = AddWatchlist(testTvDetail);
        final secondEvent = AddWatchlist(testTvDetail);

        // Act
        final equalityResult = firstEvent == secondEvent;

        // Assert
        expect(equalityResult, true);
      });

      test('props contains tv', () {
        // Arrange
        final event = AddWatchlist(testTvDetail);

        // Act
        final props = event.props;

        // Assert
        expect(props, [testTvDetail]);
      });
    });

    group('RemoveFromWatchlist', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = RemoveFromWatchlist(testTvDetail);
        final secondEvent = RemoveFromWatchlist(testTvDetail);

        // Act
        final equalityResult = firstEvent == secondEvent;

        // Assert
        expect(equalityResult, true);
      });

      test('props contains tv', () {
        // Arrange
        final event = RemoveFromWatchlist(testTvDetail);

        // Act
        final props = event.props;

        // Assert
        expect(props, [testTvDetail]);
      });
    });

    group('LoadWatchlistStatus', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = LoadWatchlistStatus(1);
        const secondEvent = LoadWatchlistStatus(1);
        const differentEvent = LoadWatchlistStatus(2);

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props contains id', () {
        // Arrange
        const tvId = 1;
        const event = LoadWatchlistStatus(tvId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [tvId]);
      });
    });

    group('FetchTvRecommendations', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = FetchTvRecommendations(1);
        const secondEvent = FetchTvRecommendations(1);
        const differentEvent = FetchTvRecommendations(2);

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props contains id', () {
        // Arrange
        const tvId = 1;
        const event = FetchTvRecommendations(tvId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [tvId]);
      });
    });

    group('Base TvDetailEvent', () {
      test('base event props should be empty', () {
        // Arrange
        final event = FetchTvDetail(1);

        // Act
        final baseProps = (event as TvDetailEvent).props;

        // Assert
        expect(baseProps, [1]);
      });
    });
  });
}