import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/domain/entities/movie.dart';
import 'package:ditonton_submission1/domain/repositories/movie_repository.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
