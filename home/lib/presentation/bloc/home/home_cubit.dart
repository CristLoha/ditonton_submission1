import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void toggleTab(bool showMovies) {
    print('toggleTab called: $showMovies');
    emit(state.copyWith(showMovies: showMovies));
  }
}
