abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeContentLoaded extends HomeState {
  final List<dynamic> forYouRecipes;
  final List<dynamic> popularRecipes;
  final List<dynamic> followingRecipes;
  
  HomeContentLoaded({
    required this.forYouRecipes,
    required this.popularRecipes,
    required this.followingRecipes,
  });
}

class HomeError extends HomeState {
  final String message;
  
  HomeError({required this.message});
}
