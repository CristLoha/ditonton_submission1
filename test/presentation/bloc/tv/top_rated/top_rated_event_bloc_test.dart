import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';

void main() {
  group('TopRatedTvEvent', () {
    group('FetchTopRatedTv', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = FetchTopRatedTv();
        final secondEvent = FetchTopRatedTv();

        // Act
        final comparisonResult = firstEvent == secondEvent;

        // Assert
        expect(comparisonResult, true);
      });

      test('props should be empty', () {
        // Arrange
        final event = FetchTopRatedTv();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });

    group('Base TopRatedTvEvent', () {
      test('base event props should be empty', () {
        // Arrange
        final event = FetchTopRatedTv() as TopRatedTvEvent;

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });
  });
}