import 'package:home/domain/repository/tv_repository.dart';

class GetWatchListStatusTv {
  final TvRepository repository;

  GetWatchListStatusTv(this.repository);

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
