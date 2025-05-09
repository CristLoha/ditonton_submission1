import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';


class SaveWatchlistMovie {
  final MovieRepository repository;

  SaveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
