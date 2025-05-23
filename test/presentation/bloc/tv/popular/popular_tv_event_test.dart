import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';

void main() {
  group('PopularTvEvent', () {
    group('FetchPopularTvData', () {
      test('supports value equality', () {
        // Arrange
        final firstEvent = FetchPopularTvData();
        final secondEvent = FetchPopularTvData();

        // Act
        final equalityResult = firstEvent == secondEvent;

        // Assert
        expect(equalityResult, true);
      });

      test('props should be empty', () {
        // Arrange
        final event = FetchPopularTvData();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });
    });

    group('Base PopularTvEvent', () {
      test('base event props should be empty', () {
        // Arrange
        final event = FetchPopularTvData() as PopularTvEvent;

        // Act
        final baseProps = event.props;

        // Assert
        expect(baseProps, []);
      });
    });
  });
}