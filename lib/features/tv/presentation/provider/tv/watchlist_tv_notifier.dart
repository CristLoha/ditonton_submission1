// import 'package:core/core.dart';
// import 'package:home/home.dart';
// import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_tv.dart';
// import 'package:flutter/foundation.dart';

// class WatchlistTvNotifier extends ChangeNotifier {
//   final GetWatchListTv getWatchlistTv;

//   WatchlistTvNotifier({required this.getWatchlistTv});

//   List<Tv> _watchlistTv = [];
//   List<Tv> get watchlistTv => _watchlistTv;

//   RequestState _watchlistState = RequestState.empty;
//   RequestState get watchlistState => _watchlistState;

//   String _message = '';
//   String get message => _message;

//   Future<void> fetchWatchlistTv() async {
//     _watchlistState = RequestState.loading;
//     notifyListeners();

//     final result = await getWatchlistTv.execute();
//     result.fold(
//       (failure) {
//         _watchlistState = RequestState.error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (tvList) {
//         _watchlistState = RequestState.loaded;
//         _watchlistTv = tvList;
//         notifyListeners();
//       },
//     );
//   }
// }
