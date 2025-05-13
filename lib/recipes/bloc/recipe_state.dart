import '../models/recipe_model.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipesLoaded({required this.recipes});
}

class RecipeDetailLoaded extends RecipeState {
  final Recipe recipe;

  RecipeDetailLoaded({required this.recipe});
}

class RecipeAdded extends RecipeState {
  final String recipeId;

  RecipeAdded({required this.recipeId});
}

class RecipeUpdated extends RecipeState {}

class RecipeDeleted extends RecipeState {}

class RecipeError extends RecipeState {
  final String message;

  RecipeError({required this.message});
}
