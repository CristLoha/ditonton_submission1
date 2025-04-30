import 'package:ditonton_submission1/core/error/failure.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/domain/repositories/tv_repository.dart';
import 'package:dartz/dartz.dart';

class GetTopRatedTv {
  final TvRepository repository;

  GetTopRatedTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}
