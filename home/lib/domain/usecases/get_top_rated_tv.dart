import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/repository/tv_repository.dart';

class GetTopRatedTv {
  final TvRepository repository;

  GetTopRatedTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}
