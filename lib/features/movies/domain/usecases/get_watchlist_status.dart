import 'package:home/home.dart';

class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> executeMovie(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
