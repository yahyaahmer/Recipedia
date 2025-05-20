import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/food_diary/models/experience_model.dart';

void main() {
  group('Experience Model Tests', () {
    test('Experience constructor creates a valid experience object', () {
      // Create a test date
      final testDate = DateTime(2023, 1, 15);

      // Create an experience using the constructor
      final experience = Experience(
        id: 'exp-123',
        recipeId: 'recipe-456',
        recipeTitle: 'Chocolate Cake',
        userId: 'user-789',
        username: 'John Doe',
        userImageUrl: 'https://example.com/user.jpg',
        rating: 5,
        comment: 'This recipe was amazing!',
        imageUrl: 'https://example.com/cake.jpg',
        createdAt: testDate,
        likes: ['user-001', 'user-002'],
      );

      // Verify the experience properties
      expect(experience.id, 'exp-123');
      expect(experience.recipeId, 'recipe-456');
      expect(experience.recipeTitle, 'Chocolate Cake');
      expect(experience.userId, 'user-789');
      expect(experience.username, 'John Doe');
      expect(experience.userImageUrl, 'https://example.com/user.jpg');
      expect(experience.rating, 5);
      expect(experience.comment, 'This recipe was amazing!');
      expect(experience.imageUrl, 'https://example.com/cake.jpg');
      expect(experience.createdAt, testDate);
      expect(experience.likes, ['user-001', 'user-002']);
      expect(experience.likes.length, 2);
    });
  });
}
