import 'package:home/home.dart';

class GetWatchListStatusMovie {
  final MovieRepository repository;

  GetWatchListStatusMovie(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
