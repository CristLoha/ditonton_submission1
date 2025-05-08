import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';
class RemoveWatchlistTv {
  final TvRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlist(tv);
  }
}
