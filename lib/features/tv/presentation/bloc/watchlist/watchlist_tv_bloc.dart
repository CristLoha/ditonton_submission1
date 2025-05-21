import 'package:bloc/bloc.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/tv.dart';
part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchListTv getWatchlistTv;
  WatchlistTvBloc(this.getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTvEvent>((event, emit) async {
      emit(WatchlistTvLoading());

      final result = await getWatchlistTv.execute();
      result.fold((failure) => emit(WatchlistTvError(failure.message)), (data) {
        if (data.isEmpty) {
          emit(WatchlistTvEmpty());
        } else {
          emit(WatchlistTvHasData(data));
        }
      });
    });
  }
}
