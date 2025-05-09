import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';
class GetWatchListTv {
  final TvRepository _repository;

  GetWatchListTv(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTv();
  }
}
