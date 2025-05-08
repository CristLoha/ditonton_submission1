import 'package:core/core.dart';
import 'package:home/home.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton_submission1/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton_submission1/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:flutter/foundation.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late TvDetail _tv;
  TvDetail? get tv => _tv;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvDetail(int id) async {
    _state = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = tvs;
          },
        );
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
        notifyListeners();
      },
      (successMessage) {
        _watchlistMessage = successMessage;
        notifyListeners();
      },
    );
    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
        notifyListeners();
      },
      (successMessage) {
        _watchlistMessage = successMessage;
        notifyListeners();
      },
    );
    await loadWatchlistStatus(tv.id);
  }
}
