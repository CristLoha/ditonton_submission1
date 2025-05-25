import 'package:flutter_test/flutter_test.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_event.dart';

void main() {
  group('MovieListEvent', () {
    group('FetchNowPlayingMovies', () {
      test('should be comparable', () {
        final event1 = FetchNowPlayingMovies();
        final event2 = FetchNowPlayingMovies();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });

    group('FetchMovieListPopularMovies', () {
      test('should be comparable', () {
        final event1 = FetchMovieListPopularMovies();
        final event2 = FetchMovieListPopularMovies();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });

    group('FetchTopRatedMovies', () {
      test('should be comparable', () {
        final event1 = FetchTopRatedMovies();
        final event2 = FetchTopRatedMovies();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });
  });
}
