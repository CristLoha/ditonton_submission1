import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:home/home.dart';

class SearchTv {
  final TvRepository repository;

  SearchTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTv(query);
  }
}

