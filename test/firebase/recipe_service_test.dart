import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/recipes/models/recipe_model.dart';
import 'package:recipe_app/recipes/services/recipe_service.dart';

// Create mock classes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  late RecipeService recipeService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  
  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    
    // Setup auth mock
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-user-id');
    when(mockUser.displayName).thenReturn('Test User');
    
    // Setup firestore collection mock
    when(mockFirestore.collection('recipes')).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);
    
    // Create RecipeService with mocked dependencies
    recipeService = RecipeService(
      firestore: mockFirestore,
      auth: mockAuth,
    );
  });
  
  group('RecipeService Tests', () {
    test('getRecipeById returns recipe when document exists', () async {
      // Arrange
      final mockDocSnapshot = MockDocumentSnapshot();
      final mockData = {
        'title': 'Test Recipe',
        'description': 'Test Description',
        'authorId': 'test-user-id',
        'authorName': 'Test User',
        'imageUrl': 'https://example.com/image.jpg',
        'cookTime': '30 mins',
        'difficulty': 'Medium',
        'ingredients': ['Ingredient 1', 'Ingredient 2'],
        'steps': ['Step 1', 'Step 2'],
        'rating': 4.5,
        'ratingCount': 10,
        'experienceCount': 5,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
      };
      
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn(mockData);
      when(mockDocSnapshot.id).thenReturn('test-recipe-id');
      
      // Act
      final result = await recipeService.getRecipeById('test-recipe-id');
      
      // Assert
      expect(result, isNotNull);
      expect(result?.id, 'test-recipe-id');
      expect(result?.title, 'Test Recipe');
      expect(result?.description, 'Test Description');
      expect(result?.authorId, 'test-user-id');
      expect(result?.authorName, 'Test User');
      verify(mockFirestore.collection('recipes')).called(1);
      verify(mockCollection.doc('test-recipe-id')).called(1);
      verify(mockDocRef.get()).called(1);
    });
    
    test('getRecipeById returns null when document does not exist', () async {
      // Arrange
      final mockDocSnapshot = MockDocumentSnapshot();
      
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(false);
      
      // Act
      final result = await recipeService.getRecipeById('non-existent-id');
      
      // Assert
      expect(result, isNull);
      verify(mockFirestore.collection('recipes')).called(1);
      verify(mockCollection.doc('non-existent-id')).called(1);
      verify(mockDocRef.get()).called(1);
    });
    
    test('addRecipe adds recipe to Firestore and returns ID', () async {
      // Arrange
      when(mockCollection.add(any)).thenAnswer((_) async => mockDocRef);
      when(mockDocRef.id).thenReturn('new-recipe-id');
      
      // Act
      final result = await recipeService.addRecipe(
        title: 'New Recipe',
        description: 'New Description',
        imageUrl: 'https://example.com/new-image.jpg',
        cookTime: '45 mins',
        difficulty: 'Easy',
        ingredients: ['New Ingredient 1', 'New Ingredient 2'],
        steps: ['New Step 1', 'New Step 2'],
      );
      
      // Assert
      expect(result, 'new-recipe-id');
      verify(mockFirestore.collection('recipes')).called(1);
      verify(mockCollection.add(any)).called(1);
    });
  });
}
