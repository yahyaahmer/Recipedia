import '../models/experience_model.dart';

abstract class DiaryEvent {}

class FetchExperiences extends DiaryEvent {}

class FetchRecipeExperiences extends DiaryEvent {
  final String recipeId;

  FetchRecipeExperiences({required this.recipeId});
}

class FetchUserExperiences extends DiaryEvent {
  final String userId;

  FetchUserExperiences({required this.userId});
}

class ExperiencesUpdated extends DiaryEvent {
  final List<Experience> experiences;

  ExperiencesUpdated({required this.experiences});
}

class AddExperience extends DiaryEvent {
  final String recipeId;
  final String recipeTitle;
  final int rating;
  final String comment;
  final String? imageUrl;

  AddExperience({
    required this.recipeId,
    required this.recipeTitle,
    required this.rating,
    required this.comment,
    this.imageUrl,
  });
}

class UpdateExperience extends DiaryEvent {
  final String experienceId;
  final int? rating;
  final String? comment;
  final String? imageUrl;

  UpdateExperience({
    required this.experienceId,
    this.rating,
    this.comment,
    this.imageUrl,
  });
}

class DeleteExperience extends DiaryEvent {
  final String experienceId;

  DeleteExperience({required this.experienceId});
}

class ToggleLikeExperience extends DiaryEvent {
  final String experienceId;

  ToggleLikeExperience({required this.experienceId});
}

class DiaryErrorEvent extends DiaryEvent {
  final String message;

  DiaryErrorEvent({required this.message});
}
