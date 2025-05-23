import 'package:core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/repository/movie_repository.dart';
import 'package:home/domain/usecases/get_now_playing_movies.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_now_playing_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockMovieRepository.getNowPlayingMovies(),
    ).thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tMovies));
  });

  test('should create GetNowPlayingMovies instance with repository', () {
    expect(usecase, isA<GetNowPlayingMovies>());
    expect(usecase.repository, mockMovieRepository);
  });

  group('Execute', () {
    final tMovies = <Movie>[];

    test(
      'should get list of movies from the repository when successful',
      () async {
        // arrange
        when(
          mockMovieRepository.getNowPlayingMovies(),
        ).thenAnswer((_) async => Right(tMovies));

        // act
        final result = await usecase.execute();

        // assert
        expect(result, Right(tMovies));
        verify(mockMovieRepository.getNowPlayingMovies());
        verifyNoMoreInteractions(mockMovieRepository);
      },
    );

    test('should return server failure when getting movies fails', () async {
      // arrange
      when(
        mockMovieRepository.getNowPlayingMovies(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, const Left(ServerFailure('Server Failure')));
      verify(mockMovieRepository.getNowPlayingMovies());
      verifyNoMoreInteractions(mockMovieRepository);
    });
  });
}
