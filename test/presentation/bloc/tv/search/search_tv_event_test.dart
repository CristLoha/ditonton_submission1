import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';

void main() {
  group('SearchTvEvent', () {
    group('OnQueryTvChanged', () {
      test('supports value equality', () {
        // Arrange
        const firstEvent = OnQueryTvChanged('spiderman');
        const secondEvent = OnQueryTvChanged('spiderman');
        const differentEvent = OnQueryTvChanged('batman');

        // Act
        final equalityResult = firstEvent == secondEvent;
        final inequalityResult = firstEvent == differentEvent;

        // Assert
        expect(equalityResult, true);
        expect(inequalityResult, false);
      });

      test('props should contain query', () {
        // Arrange
        const searchQuery = 'spiderman';
        const event = OnQueryTvChanged(searchQuery);

        // Act
        final props = event.props;

        // Assert
        expect(props, [searchQuery]);
      });
    });

    group('Base SearchTvEvent', () {
      test('base event props should be empty', () {
        // Arrange
        final event = OnQueryTvChanged('') as SearchTvEvent;

        // Act
        final baseProps = event.props;

        // Assert
        expect(baseProps, ['']);
      });
    });
  });
}