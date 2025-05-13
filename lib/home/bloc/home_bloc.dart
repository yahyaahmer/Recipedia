import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchHomeContent>(_onFetchHomeContent);
  }

  void _onFetchHomeContent(FetchHomeContent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // Implement Firebase Firestore fetch logic here
      emit(HomeContentLoaded(
        forYouRecipes: [],
        popularRecipes: [],
        followingRecipes: [],
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
