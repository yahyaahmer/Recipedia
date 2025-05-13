import '../models/recipe_model.dart';

abstract class RecipeEvent {}

class FetchRecipes extends RecipeEvent {
  final String? category;

  FetchRecipes({this.category});
}

class FetchPopularRecipes extends RecipeEvent {}

class FetchUserRecipes extends RecipeEvent {
  final String userId;

  FetchUserRecipes({required this.userId});
}

class RecipesUpdated extends RecipeEvent {
  final List<Recipe> recipes;

  RecipesUpdated({required this.recipes});
}

class FetchRecipeDetail extends RecipeEvent {
  final String recipeId;

  FetchRecipeDetail({required this.recipeId});
}

class AddRecipe extends RecipeEvent {
  final String title;
  final String description;
  final String cookTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final String? imageUrl;

  AddRecipe({
    required this.title,
    required this.description,
    required this.cookTime,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
  });
}

class UpdateRecipe extends RecipeEvent {
  final String recipeId;
  final String? title;
  final String? description;
  final String? cookTime;
  final String? difficulty;
  final List<String>? ingredients;
  final List<String>? steps;
  final String? imageUrl;

  UpdateRecipe({
    required this.recipeId,
    this.title,
    this.description,
    this.cookTime,
    this.difficulty,
    this.ingredients,
    this.steps,
    this.imageUrl,
  });
}

class DeleteRecipe extends RecipeEvent {
  final String recipeId;

  DeleteRecipe({required this.recipeId});
}

class RecipeErrorEvent extends RecipeEvent {
  final String message;

  RecipeErrorEvent({required this.message});
}
