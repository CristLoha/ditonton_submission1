import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/domain/entities/tv_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter/foundation.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
  });

  RequestState _state = RequestState.empty;

  RequestState get state => _state;
  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  TvDetail? _tvDetail;
  TvDetail? get tvDetail => _tvDetail;

  String _message = '';
  String get message => _message;

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
        _state = RequestState.loaded;
        _tvDetail = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tv) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = tv;
          },
        );
      },
    );
  }
}
