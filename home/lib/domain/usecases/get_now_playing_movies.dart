import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/repository/movie_repository.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
