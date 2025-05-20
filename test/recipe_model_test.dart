import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/recipes/models/recipe_model.dart';

void main() {
  group('Recipe Model Tests', () {
    test('Recipe constructor creates a valid recipe object', () {
      // Create a recipe using the constructor
      final recipe = Recipe(
        id: 'test-id',
        title: 'Test Recipe',
        description: 'Test Description',
        ingredients: ['Ingredient 1', 'Ingredient 2'],
        steps: ['Step 1', 'Step 2'],
        cookTime: '30 mins',
        difficulty: 'Medium',
        authorId: 'user-123',
        authorName: 'Test User',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        experienceCount: 10,
        createdAt: DateTime(2023, 1, 1),
      );

      // Verify the recipe properties
      expect(recipe.id, 'test-id');
      expect(recipe.title, 'Test Recipe');
      expect(recipe.description, 'Test Description');
      expect(recipe.ingredients, ['Ingredient 1', 'Ingredient 2']);
      expect(recipe.steps, ['Step 1', 'Step 2']);
      expect(recipe.cookTime, '30 mins');
      expect(recipe.difficulty, 'Medium');
      expect(recipe.authorId, 'user-123');
      expect(recipe.authorName, 'Test User');
      expect(recipe.imageUrl, 'https://example.com/image.jpg');
      expect(recipe.rating, 4.5);
      expect(recipe.experienceCount, 10);
      expect(recipe.createdAt, DateTime(2023, 1, 1));
    });
  });
}
