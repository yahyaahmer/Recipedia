import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/recipes/models/recipe_model.dart';
import 'package:recipe_app/recipes/services/recipe_service.dart';

// Create mock classes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late RecipeService recipeService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  
  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    
    // Setup firestore collection mock
    when(mockFirestore.collection('recipes')).thenReturn(mockCollection);
    
    // Create RecipeService with mocked dependencies
    recipeService = RecipeService(
      firestore: mockFirestore,
    );
  });
  
  group('Recipe Filtering Tests', () {
    test('getRecipes without filter returns all recipes ordered by createdAt', () async {
      // Arrange
      final mockQueryDocSnapshot1 = MockQueryDocumentSnapshot();
      final mockQueryDocSnapshot2 = MockQueryDocumentSnapshot();
      final mockQueryDocSnapshot3 = MockQueryDocumentSnapshot();
      
      when(mockCollection.orderBy('createdAt', descending: true)).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([
        mockQueryDocSnapshot1,
        mockQueryDocSnapshot2,
        mockQueryDocSnapshot3,
      ]);
      
      // Setup mock document data
      when(mockQueryDocSnapshot1.id).thenReturn('recipe-1');
      when(mockQueryDocSnapshot1.data()).thenReturn({
        'title': 'Recipe 1',
        'description': 'Description 1',
        'authorId': 'user-1',
        'authorName': 'User 1',
        'imageUrl': '',
        'cookTime': '30 mins',
        'difficulty': 'Easy',
        'ingredients': ['Ingredient 1'],
        'steps': ['Step 1'],
        'rating': 4.5,
        'ratingCount': 10,
        'experienceCount': 5,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 3)),
      });
      
      when(mockQueryDocSnapshot2.id).thenReturn('recipe-2');
      when(mockQueryDocSnapshot2.data()).thenReturn({
        'title': 'Recipe 2',
        'description': 'Description 2',
        'authorId': 'user-2',
        'authorName': 'User 2',
        'imageUrl': '',
        'cookTime': '45 mins',
        'difficulty': 'Medium',
        'ingredients': ['Ingredient 2'],
        'steps': ['Step 2'],
        'rating': 4.0,
        'ratingCount': 8,
        'experienceCount': 3,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
      });
      
      when(mockQueryDocSnapshot3.id).thenReturn('recipe-3');
      when(mockQueryDocSnapshot3.data()).thenReturn({
        'title': 'Recipe 3',
        'description': 'Description 3',
        'authorId': 'user-3',
        'authorName': 'User 3',
        'imageUrl': '',
        'cookTime': '60 mins',
        'difficulty': 'Hard',
        'ingredients': ['Ingredient 3'],
        'steps': ['Step 3'],
        'rating': 4.8,
        'ratingCount': 5,
        'experienceCount': 2,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
      });
      
      // Act
      final recipesStream = recipeService.getRecipes();
      
      // Assert
      expect(recipesStream, emits(isA<List<Recipe>>()));
      
      // Verify the stream content
      recipesStream.listen((recipes) {
        expect(recipes.length, 3);
        expect(recipes[0].id, 'recipe-1');
        expect(recipes[0].difficulty, 'Easy');
        expect(recipes[1].id, 'recipe-2');
        expect(recipes[1].difficulty, 'Medium');
        expect(recipes[2].id, 'recipe-3');
        expect(recipes[2].difficulty, 'Hard');
      });
      
      verify(mockCollection.orderBy('createdAt', descending: true)).called(1);
    });
    
    test('getRecipes with difficulty filter returns filtered recipes', () async {
      // Arrange
      final mockFilterQuery = MockQuery();
      final mockFilterQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocSnapshot1 = MockQueryDocumentSnapshot();
      final mockQueryDocSnapshot2 = MockQueryDocumentSnapshot();
      
      when(mockCollection.where('difficulty', isEqualTo: 'Medium')).thenReturn(mockFilterQuery);
      when(mockFilterQuery.snapshots()).thenAnswer((_) => Stream.value(mockFilterQuerySnapshot));
      when(mockFilterQuerySnapshot.docs).thenReturn([
        mockQueryDocSnapshot1,
        mockQueryDocSnapshot2,
      ]);
      
      // Setup mock document data
      when(mockQueryDocSnapshot1.id).thenReturn('recipe-2');
      when(mockQueryDocSnapshot1.data()).thenReturn({
        'title': 'Recipe 2',
        'description': 'Description 2',
        'authorId': 'user-2',
        'authorName': 'User 2',
        'imageUrl': '',
        'cookTime': '45 mins',
        'difficulty': 'Medium',
        'ingredients': ['Ingredient 2'],
        'steps': ['Step 2'],
        'rating': 4.0,
        'ratingCount': 8,
        'experienceCount': 3,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
      });
      
      when(mockQueryDocSnapshot2.id).thenReturn('recipe-4');
      when(mockQueryDocSnapshot2.data()).thenReturn({
        'title': 'Recipe 4',
        'description': 'Description 4',
        'authorId': 'user-4',
        'authorName': 'User 4',
        'imageUrl': '',
        'cookTime': '40 mins',
        'difficulty': 'Medium',
        'ingredients': ['Ingredient 4'],
        'steps': ['Step 4'],
        'rating': 3.5,
        'ratingCount': 6,
        'experienceCount': 1,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 4)),
      });
      
      // Act
      final recipesStream = recipeService.getRecipes(difficultyFilter: 'Medium');
      
      // Assert
      expect(recipesStream, emits(isA<List<Recipe>>()));
      
      // Verify the stream content
      recipesStream.listen((recipes) {
        expect(recipes.length, 2);
        expect(recipes.every((recipe) => recipe.difficulty == 'Medium'), isTrue);
        expect(recipes[0].id, 'recipe-4'); // Sorted by createdAt descending
        expect(recipes[1].id, 'recipe-2');
      });
      
      verify(mockCollection.where('difficulty', isEqualTo: 'Medium')).called(1);
    });
  });
}
