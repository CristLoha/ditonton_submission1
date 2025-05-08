import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';

class GetTvDetail {
  final TvRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
