import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/food_diary/models/experience_model.dart';
import 'package:recipe_app/food_diary/services/experience_service.dart';
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
class MockRecipeService extends Mock implements RecipeService {}
class MockTransaction extends Mock implements Transaction {}

void main() {
  late ExperienceService experienceService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockExperiencesCollection;
  late MockCollectionReference mockRecipesCollection;
  late MockDocumentReference mockExperienceDocRef;
  late MockDocumentReference mockRecipeDocRef;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;
  late MockRecipeService mockRecipeService;
  late MockTransaction mockTransaction;
  
  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockExperiencesCollection = MockCollectionReference();
    mockRecipesCollection = MockCollectionReference();
    mockExperienceDocRef = MockDocumentReference();
    mockRecipeDocRef = MockDocumentReference();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockRecipeService = MockRecipeService();
    mockTransaction = MockTransaction();
    
    // Setup auth mock
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-user-id');
    when(mockUser.displayName).thenReturn('Test User');
    
    // Setup firestore collection mocks
    when(mockFirestore.collection('experiences')).thenReturn(mockExperiencesCollection);
    when(mockFirestore.collection('recipes')).thenReturn(mockRecipesCollection);
    when(mockExperiencesCollection.doc(any)).thenReturn(mockExperienceDocRef);
    when(mockRecipesCollection.doc(any)).thenReturn(mockRecipeDocRef);
    
    // Setup transaction mock
    when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
      final Function transaction = invocation.positionalArguments[0];
      return await transaction(mockTransaction);
    });
    
    // Create ExperienceService with mocked dependencies
    experienceService = ExperienceService(
      firestore: mockFirestore,
      auth: mockAuth,
      recipeService: mockRecipeService,
    );
  });
  
  group('ExperienceService Tests', () {
    test('addExperience adds experience to Firestore and returns ID', () async {
      // Arrange
      when(mockExperiencesCollection.add(any)).thenAnswer((_) async => mockExperienceDocRef);
      when(mockExperienceDocRef.id).thenReturn('new-experience-id');
      
      // Mock recipe service updateRecipeRating
      when(mockRecipeService.updateRecipeRating(any, any)).thenAnswer((_) async => null);
      
      // Mock transaction for incrementExperienceCount
      final mockRecipeSnapshot = MockDocumentSnapshot();
      when(mockTransaction.get(mockRecipeDocRef)).thenAnswer((_) async => mockRecipeSnapshot);
      when(mockRecipeSnapshot.exists).thenReturn(true);
      when(mockRecipeSnapshot.data()).thenReturn({'experienceCount': 5});
      
      // Act
      final result = await experienceService.addExperience(
        recipeId: 'test-recipe-id',
        recipeTitle: 'Test Recipe',
        rating: 5,
        comment: 'Great recipe!',
        imageUrl: 'https://example.com/experience.jpg',
      );
      
      // Assert
      expect(result, 'new-experience-id');
      verify(mockFirestore.collection('experiences')).called(1);
      verify(mockExperiencesCollection.add(any)).called(1);
      verify(mockRecipeService.updateRecipeRating('test-recipe-id', 5.0)).called(1);
      verify(mockFirestore.runTransaction(any)).called(1);
    });
    
    test('getRecipeExperiences returns stream of experiences for a recipe', () async {
      // Arrange
      final mockQuery = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocSnapshot1 = MockQueryDocumentSnapshot();
      final mockQueryDocSnapshot2 = MockQueryDocumentSnapshot();
      
      when(mockExperiencesCollection.where('recipeId', isEqualTo: 'test-recipe-id'))
          .thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => 
          Stream.value(mockQuerySnapshot));
      
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot1, mockQueryDocSnapshot2]);
      
      when(mockQueryDocSnapshot1.id).thenReturn('exp-1');
      when(mockQueryDocSnapshot1.data()).thenReturn({
        'recipeId': 'test-recipe-id',
        'recipeTitle': 'Test Recipe',
        'userId': 'user-1',
        'username': 'User 1',
        'userImageUrl': '',
        'rating': 5,
        'comment': 'Great!',
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
        'likes': [],
      });
      
      when(mockQueryDocSnapshot2.id).thenReturn('exp-2');
      when(mockQueryDocSnapshot2.data()).thenReturn({
        'recipeId': 'test-recipe-id',
        'recipeTitle': 'Test Recipe',
        'userId': 'user-2',
        'username': 'User 2',
        'userImageUrl': '',
        'rating': 4,
        'comment': 'Good!',
        'imageUrl': '',
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
        'likes': ['user-1'],
      });
      
      // Act
      final stream = experienceService.getRecipeExperiences('test-recipe-id');
      
      // Assert
      expect(stream, emits(isA<List<Experience>>()));
      
      // Verify the stream content
      stream.listen((experiences) {
        expect(experiences.length, 2);
        expect(experiences[0].id, 'exp-1');
        expect(experiences[0].rating, 5);
        expect(experiences[1].id, 'exp-2');
        expect(experiences[1].rating, 4);
      });
      
      verify(mockExperiencesCollection.where('recipeId', isEqualTo: 'test-recipe-id')).called(1);
    });
    
    test('toggleLike adds user ID to likes array when not liked', () async {
      // Arrange
      final mockDocSnapshot = MockDocumentSnapshot();
      
      when(mockExperienceDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'likes': [],
      });
      when(mockExperienceDocRef.update(any)).thenAnswer((_) async => null);
      
      // Act
      await experienceService.toggleLike('test-experience-id');
      
      // Assert
      verify(mockExperienceDocRef.get()).called(1);
      verify(mockExperienceDocRef.update({'likes': ['test-user-id']})).called(1);
    });
    
    test('toggleLike removes user ID from likes array when already liked', () async {
      // Arrange
      final mockDocSnapshot = MockDocumentSnapshot();
      
      when(mockExperienceDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'likes': ['test-user-id', 'other-user-id'],
      });
      when(mockExperienceDocRef.update(any)).thenAnswer((_) async => null);
      
      // Act
      await experienceService.toggleLike('test-experience-id');
      
      // Assert
      verify(mockExperienceDocRef.get()).called(1);
      verify(mockExperienceDocRef.update({'likes': ['other-user-id']})).called(1);
    });
  });
}
