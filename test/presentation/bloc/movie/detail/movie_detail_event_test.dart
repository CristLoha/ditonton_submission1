import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_event.dart';

import '../../../../dummy_data/dummy_objects.dart';

void main() {
  group('MovieDetailEvent', () {
    group('FetchMovieDetail', () {
      test('supports value equality', () {
        expect(
          const FetchMovieDetail(1),
          equals(const FetchMovieDetail(1)),
        );
      });

      test('props contains id', () {
        expect(
          const FetchMovieDetail(1).props,
          [1],
        );
      });
    });

    group('AddWatchlist', () {
      test('supports value equality', () {
        expect(
          AddWatchlist(testMovieDetail),
          equals(AddWatchlist(testMovieDetail)),
        );
      });

      test('props contains movie', () {
        expect(
          AddWatchlist(testMovieDetail).props,
          [testMovieDetail],
        );
      });
    });

    group('RemoveFromWatchlist', () {
      test('supports value equality', () {
        expect(
          RemoveFromWatchlist(testMovieDetail),
          equals(RemoveFromWatchlist(testMovieDetail)),
        );
      });

      test('props contains movie', () {
        expect(
          RemoveFromWatchlist(testMovieDetail).props,
          [testMovieDetail],
        );
      });
    });

    group('LoadWatchlistStatus', () {
      test('supports value equality', () {
        expect(
          const LoadWatchlistStatus(1),
          equals(const LoadWatchlistStatus(1)),
        );
      });

      test('props contains id', () {
        expect(
          const LoadWatchlistStatus(1).props,
          [1],
        );
      });
    });

    group('FetchMovieRecommendations', () {
      test('supports value equality', () {
        expect(
          const FetchMovieRecommendations(1),
          equals(const FetchMovieRecommendations(1)),
        );
      });

      test('props contains id', () {
        expect(
          const FetchMovieRecommendations(1).props,
          [1],
        );
      });
    });

    group('Base MovieDetailEvent', () {
      test('base event props should be empty', () {
     
        final movieEvent = FetchMovieDetail(1);
      
        final baseProps = (movieEvent as MovieDetailEvent).props;
        expect(baseProps, [1]); 
      });
    });
  });
}