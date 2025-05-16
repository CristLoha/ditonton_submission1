import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/domain/usecases/get_popular_tv.dart';
part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;
  PopularTvBloc(this.getPopularTv) : super(PopularTvEmpty()) {
    on<PopularTvEvent>((event, emit) async {
      emit(PopularTvLoading());
      final result = await getPopularTv.execute();
      result.fold(
        (failure) => emit(PopularTvError(failure.message)),
        (data) => emit(PopularTvHasData(data)),
      );
    });
  }
}
