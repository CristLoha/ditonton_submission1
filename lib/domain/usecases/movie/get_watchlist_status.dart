import 'package:ditonton_submission1/domain/repositories/movie_repository.dart';

class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> executeMovie(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
