import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeService _recipeService = RecipeService();
  StreamSubscription? _recipesSubscription;

  RecipeBloc() : super(RecipeInitial()) {
    on<FetchRecipes>(_onFetchRecipes);
    on<FetchPopularRecipes>(_onFetchPopularRecipes);
    on<FetchUserRecipes>(_onFetchUserRecipes);
    on<FetchRecipeDetail>(_onFetchRecipeDetail);
    on<AddRecipe>(_onAddRecipe);
    on<UpdateRecipe>(_onUpdateRecipe);
    on<DeleteRecipe>(_onDeleteRecipe);
    on<RecipesUpdated>(_onRecipesUpdated);
    on<RecipeErrorEvent>(_onRecipeError);
  }

  void _onRecipesUpdated(RecipesUpdated event, Emitter<RecipeState> emit) {
    emit(RecipesLoaded(recipes: event.recipes));
  }

  void _onRecipeError(RecipeErrorEvent event, Emitter<RecipeState> emit) {
    emit(RecipeError(message: event.message));
  }

  void _onFetchRecipes(FetchRecipes event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      await _recipesSubscription?.cancel();
      _recipesSubscription = _recipeService.getRecipes().listen(
        (recipes) {
          add(RecipesUpdated(recipes: recipes));
        },
        onError: (error) {
          add(RecipeErrorEvent(message: error.toString()));
        },
      );
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onFetchPopularRecipes(
    FetchPopularRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      await _recipesSubscription?.cancel();
      _recipesSubscription = _recipeService.getPopularRecipes().listen(
        (recipes) {
          add(RecipesUpdated(recipes: recipes));
        },
        onError: (error) {
          add(RecipeErrorEvent(message: error.toString()));
        },
      );
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onFetchUserRecipes(
    FetchUserRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      await _recipesSubscription?.cancel();
      _recipesSubscription = _recipeService
          .getUserRecipes(event.userId)
          .listen(
            (recipes) {
              add(RecipesUpdated(recipes: recipes));
            },
            onError: (error) {
              add(RecipeErrorEvent(message: error.toString()));
            },
          );
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onFetchRecipeDetail(
    FetchRecipeDetail event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      Recipe? recipe = await _recipeService.getRecipeById(event.recipeId);
      if (recipe != null) {
        emit(RecipeDetailLoaded(recipe: recipe));
      } else {
        emit(RecipeError(message: 'Recipe not found'));
      }
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onAddRecipe(AddRecipe event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      String recipeId = await _recipeService.addRecipe(
        title: event.title,
        description: event.description,
        imageUrl: event.imageUrl ?? '',
        cookTime: event.cookTime,
        difficulty: event.difficulty,
        ingredients: event.ingredients,
        steps: event.steps,
      );
      emit(RecipeAdded(recipeId: recipeId));
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onUpdateRecipe(UpdateRecipe event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      await _recipeService.updateRecipe(
        recipeId: event.recipeId,
        title: event.title,
        description: event.description,
        imageUrl: event.imageUrl,
        cookTime: event.cookTime,
        difficulty: event.difficulty,
        ingredients: event.ingredients,
        steps: event.steps,
      );
      emit(RecipeUpdated());
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  void _onDeleteRecipe(DeleteRecipe event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
      await _recipeService.deleteRecipe(event.recipeId);
      emit(RecipeDeleted());
    } catch (e) {
      emit(RecipeError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    return super.close();
  }
}
