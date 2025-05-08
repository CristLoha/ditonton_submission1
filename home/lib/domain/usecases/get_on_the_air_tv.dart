import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/repository/tv_repository.dart';

class GetOnTheAirTv {
  final TvRepository repository;

  GetOnTheAirTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTv();
  }
}
