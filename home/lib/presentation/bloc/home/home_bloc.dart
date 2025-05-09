import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'package:home/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ToggleTab>((event, emit) {
      emit(state.copyWith(showMovies: event.showMovies));
    });
  }
}