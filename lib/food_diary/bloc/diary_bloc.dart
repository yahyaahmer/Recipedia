import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/experience_model.dart';
import '../services/experience_service.dart';
import 'diary_event.dart';
import 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final ExperienceService _experienceService = ExperienceService();
  StreamSubscription? _experiencesSubscription;

  DiaryBloc() : super(DiaryInitial()) {
    on<FetchExperiences>(_onFetchExperiences);
    on<FetchRecipeExperiences>(_onFetchRecipeExperiences);
    on<FetchUserExperiences>(_onFetchUserExperiences);
    on<AddExperience>(_onAddExperience);
    on<UpdateExperience>(_onUpdateExperience);
    on<DeleteExperience>(_onDeleteExperience);
    on<ToggleLikeExperience>(_onToggleLikeExperience);
    on<ExperiencesUpdated>(_onExperiencesUpdated);
    on<DiaryErrorEvent>(_onDiaryError);
  }

  void _onDiaryError(DiaryErrorEvent event, Emitter<DiaryState> emit) {
    emit(DiaryError(message: event.message));
  }

  void _onFetchExperiences(
    FetchExperiences event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      await _experiencesSubscription?.cancel();
      _experiencesSubscription = _experienceService.getExperiences().listen(
        (experiences) {
          add(ExperiencesUpdated(experiences: experiences));
        },
        onError: (error) {
          add(DiaryErrorEvent(message: error.toString()));
        },
      );
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onFetchRecipeExperiences(
    FetchRecipeExperiences event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      await _experiencesSubscription?.cancel();
      _experiencesSubscription = _experienceService
          .getRecipeExperiences(event.recipeId)
          .listen(
            (experiences) {
              add(ExperiencesUpdated(experiences: experiences));
            },
            onError: (error) {
              add(DiaryErrorEvent(message: error.toString()));
            },
          );
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onFetchUserExperiences(
    FetchUserExperiences event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      await _experiencesSubscription?.cancel();
      _experiencesSubscription = _experienceService
          .getUserExperiences(event.userId)
          .listen(
            (experiences) {
              add(ExperiencesUpdated(experiences: experiences));
            },
            onError: (error) {
              add(DiaryErrorEvent(message: error.toString()));
            },
          );
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onExperiencesUpdated(
    ExperiencesUpdated event,
    Emitter<DiaryState> emit,
  ) {
    emit(ExperiencesLoaded(experiences: event.experiences));
  }

  void _onAddExperience(AddExperience event, Emitter<DiaryState> emit) async {
    emit(DiaryLoading());
    try {
      String experienceId = await _experienceService.addExperience(
        recipeId: event.recipeId,
        recipeTitle: event.recipeTitle,
        rating: event.rating,
        comment: event.comment,
        imageUrl: event.imageUrl ?? '',
      );
      emit(ExperienceAdded(experienceId: experienceId));
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onUpdateExperience(
    UpdateExperience event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      await _experienceService.updateExperience(
        experienceId: event.experienceId,
        rating: event.rating,
        comment: event.comment,
        imageUrl: event.imageUrl,
      );
      emit(ExperienceUpdated());
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onDeleteExperience(
    DeleteExperience event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      await _experienceService.deleteExperience(event.experienceId);
      emit(ExperienceDeleted());
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  void _onToggleLikeExperience(
    ToggleLikeExperience event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await _experienceService.toggleLike(event.experienceId);
      // No need to emit a new state as the stream will update
    } catch (e) {
      emit(DiaryError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _experiencesSubscription?.cancel();
    return super.close();
  }
}
