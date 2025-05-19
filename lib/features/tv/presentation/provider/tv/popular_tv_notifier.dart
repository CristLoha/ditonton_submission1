// import 'package:core/core.dart';
//   import 'package:home/domain/entities/tv.dart';
//   import 'package:flutter/foundation.dart';
// import 'package:home/domain/usecases/get_popular_tv.dart';

// class PopularTvNotifier extends ChangeNotifier {
//   final GetPopularTv getPopularTv;

//   PopularTvNotifier(this.getPopularTv);

//   RequestState _state = RequestState.empty;
//   RequestState get state => _state;

//   List<Tv> _tv = [];
//   List<Tv> get tv => _tv;

//   String _message = '';
//   String get message => _message;

//   Future<void> fetchPopularTv() async {
//     _state = RequestState.loading;
//     notifyListeners();
//     final result = await getPopularTv.execute();
//     result.fold(
//       (failure) {
//         _message = failure.message;
//         _state = RequestState.error;
//         notifyListeners();
//       },
//       (tvData) {
//         _state = RequestState.loaded;
//         _tv = tvData;
//         notifyListeners();
//       },
//     );
//   }
// }
