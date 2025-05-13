import '../models/user_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded({required this.profile});
}

class SavedRecipesLoaded extends ProfileState {
  final List<String> recipeIds;

  SavedRecipesLoaded({required this.recipeIds});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
