import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/recipes/models/recipe_model.dart';

void main() {
  group('Difficulty Filter Tests', () {
    test('Filter recipes by difficulty level', () {
      // Create a list of test recipes with different difficulty levels
      final recipes = [
        Recipe(
          id: '1',
          title: 'Easy Recipe',
          description: '',
          ingredients: [],
          steps: [],
          cookTime: '',

          difficulty: 'Easy',
          authorId: '',
          authorName: '',
          imageUrl: '',
          rating: 0,
          experienceCount: 0,
          createdAt: DateTime.now(),
        ),
        Recipe(
          id: '2',
          title: 'Medium Recipe',
          description: '',
          ingredients: [],
          steps: [],
          cookTime: '',

          difficulty: 'Medium',
          authorId: '',
          authorName: '',
          imageUrl: '',
          rating: 0,
          experienceCount: 0,
          createdAt: DateTime.now(),
        ),
        Recipe(
          id: '3',
          title: 'Hard Recipe',
          description: '',
          ingredients: [],
          steps: [],
          cookTime: '',

          difficulty: 'Hard',
          authorId: '',
          authorName: '',
          imageUrl: '',
          rating: 0,
          experienceCount: 0,
          createdAt: DateTime.now(),
        ),
        Recipe(
          id: '4',
          title: 'Another Easy Recipe',
          description: '',
          ingredients: [],
          steps: [],
          cookTime: '',

          difficulty: 'Easy',
          authorId: '',
          authorName: '',
          imageUrl: '',
          rating: 0,
          experienceCount: 0,
          createdAt: DateTime.now(),
        ),
      ];

      // Filter recipes by difficulty
      final easyRecipes =
          recipes.where((recipe) => recipe.difficulty == 'Easy').toList();
      final mediumRecipes =
          recipes.where((recipe) => recipe.difficulty == 'Medium').toList();
      final hardRecipes =
          recipes.where((recipe) => recipe.difficulty == 'Hard').toList();

      // Verify filter results
      expect(easyRecipes.length, 2);
      expect(mediumRecipes.length, 1);
      expect(hardRecipes.length, 1);

      expect(easyRecipes[0].title, 'Easy Recipe');
      expect(easyRecipes[1].title, 'Another Easy Recipe');
      expect(mediumRecipes[0].title, 'Medium Recipe');
      expect(hardRecipes[0].title, 'Hard Recipe');
    });
  });
}
