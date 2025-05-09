import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';


class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
