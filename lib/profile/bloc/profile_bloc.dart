import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_profile_model.dart';
import '../services/profile_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService = ProfileService();

  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<FetchCurrentUserProfile>(_onFetchCurrentUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ToggleFollowUser>(_onToggleFollowUser);
    on<ToggleSaveRecipe>(_onToggleSaveRecipe);
    on<FetchSavedRecipes>(_onFetchSavedRecipes);
    on<ProfileErrorEvent>(_onProfileError);
  }

  void _onProfileError(ProfileErrorEvent event, Emitter<ProfileState> emit) {
    emit(ProfileError(message: event.message));
  }

  void _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      UserProfile? profile = await _profileService.getUserProfile(event.userId);
      if (profile != null) {
        emit(ProfileLoaded(profile: profile));
      } else {
        emit(ProfileError(message: 'User profile not found'));
      }
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }

  void _onFetchCurrentUserProfile(
    FetchCurrentUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      UserProfile? profile = await _profileService.getCurrentUserProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile: profile));
      } else {
        // Create a new profile if it doesn't exist
        await _profileService.createOrUpdateUserProfile();
        profile = await _profileService.getCurrentUserProfile();
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        } else {
          emit(ProfileError(message: 'Failed to create user profile'));
        }
      }
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileService.createOrUpdateUserProfile(
        username: event.username,
        bio: event.bio,
        profileImageUrl: event.profileImageUrl,
        coverImageUrl: event.coverImageUrl,
      );

      // Fetch updated profile
      UserProfile? profile = await _profileService.getCurrentUserProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile: profile));
      } else {
        emit(ProfileError(message: 'Failed to load updated profile'));
      }
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }

  void _onToggleFollowUser(
    ToggleFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileService.toggleFollow(event.targetUserId);

      // Refresh the profile
      add(FetchUserProfile(userId: event.targetUserId));
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }

  void _onToggleSaveRecipe(
    ToggleSaveRecipe event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileService.toggleSaveRecipe(event.recipeId);

      // Refresh saved recipes
      add(FetchSavedRecipes());
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }

  void _onFetchSavedRecipes(
    FetchSavedRecipes event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      List<String> savedRecipeIds = await _profileService.getSavedRecipeIds();
      emit(SavedRecipesLoaded(recipeIds: savedRecipeIds));
    } catch (e) {
      add(ProfileErrorEvent(message: e.toString()));
    }
  }
}
