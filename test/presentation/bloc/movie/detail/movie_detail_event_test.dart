import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_event.dart';
import '../../../../dummy_data/dummy_objects.dart';

void main() {
  group('MovieDetailEvent', () {
    group('FetchMovieDetail', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = FetchMovieDetail(1);
        const secondEvent = FetchMovieDetail(1);
        const differentEvent = FetchMovieDetail(2);

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props contains id', () {
        // Arrange
        const movieId = 1;
        const event = FetchMovieDetail(movieId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [movieId]);
      });
    });

    group('AddWatchlist', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = AddWatchlist(testMovieDetail);
        final secondEvent = AddWatchlist(testMovieDetail);

        // Act
        final equalityResult = firstEvent == secondEvent;

        // Assert
        expect(equalityResult, true);
      });

      test('props contains movie', () {
        // Arrange
        final event = AddWatchlist(testMovieDetail);

        // Act
        final props = event.props;

        // Assert
        expect(props, [testMovieDetail]);
      });
    });

    group('RemoveFromWatchlist', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = RemoveFromWatchlist(testMovieDetail);
        final secondEvent = RemoveFromWatchlist(testMovieDetail);

        // Act
        final equalityResult = firstEvent == secondEvent;

        // Assert
        expect(equalityResult, true);
      });

      test('props contains movie', () {
        // Arrange
        final event = RemoveFromWatchlist(testMovieDetail);

        // Act
        final props = event.props;

        // Assert
        expect(props, [testMovieDetail]);
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
        const movieId = 1;
        const event = LoadWatchlistStatus(movieId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [movieId]);
      });
    });

    group('FetchMovieRecommendations', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = FetchMovieRecommendations(1);
        const secondEvent = FetchMovieRecommendations(1);
        const differentEvent = FetchMovieRecommendations(2);

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props contains id', () {
        // Arrange
        const movieId = 1;
        const event = FetchMovieRecommendations(movieId);

        // Act
        final props = event.props;

        // Assert
        expect(props, [movieId]);
      });
    });

    group('Base MovieDetailEvent', () {
      test('base event props should contain correct values', () {
        // Arrange
        final event = FetchMovieDetail(1);

        // Act
        final baseProps = (event as MovieDetailEvent).props;

        // Assert
        expect(baseProps, [1]);
      });
    });
  });
}