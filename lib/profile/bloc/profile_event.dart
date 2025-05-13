abstract class ProfileEvent {}

class FetchUserProfile extends ProfileEvent {
  final String userId;

  FetchUserProfile({required this.userId});
}

class FetchCurrentUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String? username;
  final String? bio;
  final String? profileImageUrl;
  final String? coverImageUrl;

  UpdateUserProfile({
    this.username,
    this.bio,
    this.profileImageUrl,
    this.coverImageUrl,
  });
}

class ToggleFollowUser extends ProfileEvent {
  final String targetUserId;

  ToggleFollowUser({required this.targetUserId});
}

class ToggleSaveRecipe extends ProfileEvent {
  final String recipeId;

  ToggleSaveRecipe({required this.recipeId});
}

class FetchSavedRecipes extends ProfileEvent {}

class ProfileErrorEvent extends ProfileEvent {
  final String message;

  ProfileErrorEvent({required this.message});
}
