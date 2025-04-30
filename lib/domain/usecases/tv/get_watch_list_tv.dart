import 'package:dartz/dartz.dart';
import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/domain/repositories/tv_repository.dart';

class GetWatchListTv {
  final TvRepository repository;

  GetWatchListTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getWatchlistTv();
  }
}
