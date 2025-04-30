import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/domain/entities/tv_detail.dart';
import 'package:ditonton_submission1/domain/repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveWatchlist(tv);
  }
}
