import '../models/experience_model.dart';

abstract class DiaryState {}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class ExperiencesLoaded extends DiaryState {
  final List<Experience> experiences;

  ExperiencesLoaded({required this.experiences});
}

class ExperienceAdded extends DiaryState {
  final String experienceId;

  ExperienceAdded({required this.experienceId});
}

class ExperienceUpdated extends DiaryState {}

class ExperienceDeleted extends DiaryState {}

class DiaryError extends DiaryState {
  final String message;

  DiaryError({required this.message});
}
