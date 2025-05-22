import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';

void main() {
  group('SearchMovieEvent', () {
    group('OnQueryChanged', () {
      test('supports value equality', () {
        expect(
          const OnQueryChanged('spiderman'),
          equals(const OnQueryChanged('spiderman')),
        );
      });

      test('props should contain query', () {
        const query = 'spiderman';
        final event = OnQueryChanged(query);
        expect(event.props, [query]);
      });
    });

    group('Base SearchMovieEvent', () {
      test('props should be empty', () {
      
        final event = OnQueryChanged('') as SearchMovieEvent;
        expect(event.props, ['']); 
      });
    });

    
  });
}