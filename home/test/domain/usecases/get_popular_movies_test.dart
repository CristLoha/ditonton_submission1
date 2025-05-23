import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/usecases/get_popular_movies.dart';
import 'package:mockito/mockito.dart';

import 'get_now_playing_movies_test.mocks.dart';


void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  final tMovies = <Movie>[];

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
        'should get list of movies from the repository when execute function is called',
        () async {
          // arrange
          when(
            mockMovieRpository.getPopularMovies(),
          ).thenAnswer((_) async => Right(tMovies));
          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(tMovies));
        },
      );
    });
  });
}
