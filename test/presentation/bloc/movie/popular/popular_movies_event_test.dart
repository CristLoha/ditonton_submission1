import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/popular/popular_movies_bloc.dart';

void main() {
  group('PopularMoviesEvent', () {
    group('FetchPopularMoviesData', () {
      test('props should be empty', () {
        // Arrange
        final event = FetchPopularMoviesData();

        // Act
        final props = event.props;

        // Assert
        expect(props, []);
      });

      test('supports value equality', () {
        // Arrange
        final eventPertama = FetchPopularMoviesData();
        final eventKedua = FetchPopularMoviesData();

        // Act
        final hasilPerbandingan = eventPertama == eventKedua;

        // Assert
        expect(hasilPerbandingan, true);
      });
    });
  });
}