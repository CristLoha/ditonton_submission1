import 'package:core/core.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/repository/tv_repository.dart';
import 'package:dartz/dartz.dart';

class GetWatchListTv {
  final TvRepository repository;

  GetWatchListTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getWatchlistTv();
  }
}
