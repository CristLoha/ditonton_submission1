import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/repository/movie_repository.dart';


class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedMovies();
  }
}
