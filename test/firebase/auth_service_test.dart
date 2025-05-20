import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/auth/services/auth_service.dart';

// Create mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  
  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    
    // Setup user mock
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-user-id');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockUser.email).thenReturn('test@example.com');
    
    // Create AuthService with mocked dependencies
    authService = AuthService(auth: mockAuth);
  });
  
  group('AuthService Tests', () {
    test('signIn calls Firebase Auth signInWithEmailAndPassword', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      
      when(mockAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
      
      // Act
      final result = await authService.signIn(
        email: email,
        password: password,
      );
      
      // Assert
      expect(result, mockUser);
      verify(mockAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
    });
    
    test('signIn throws exception when Firebase Auth throws', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'wrong-password';
      
      when(mockAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
      
      // Act & Assert
      expect(
        () => authService.signIn(email: email, password: password),
        throwsA(isA<Exception>()),
      );
      verify(mockAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
    });
    
    test('signUp calls Firebase Auth createUserWithEmailAndPassword and updates profile', () async {
      // Arrange
      final email = 'new@example.com';
      final password = 'password123';
      final name = 'New User';
      
      when(mockAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);
      
      when(mockUser.updateDisplayName(name)).thenAnswer((_) async => null);
      
      // Act
      final result = await authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      
      // Assert
      expect(result, mockUser);
      verify(mockAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);
      verify(mockUser.updateDisplayName(name)).called(1);
    });
    
    test('signOut calls Firebase Auth signOut', () async {
      // Arrange
      when(mockAuth.signOut()).thenAnswer((_) async => null);
      
      // Act
      await authService.signOut();
      
      // Assert
      verify(mockAuth.signOut()).called(1);
    });
    
    test('getCurrentUser returns current user from Firebase Auth', () {
      // Arrange
      when(mockAuth.currentUser).thenReturn(mockUser);
      
      // Act
      final result = authService.getCurrentUser();
      
      // Assert
      expect(result, mockUser);
      verify(mockAuth.currentUser).called(1);
    });
    
    test('authStateChanges returns stream from Firebase Auth', () {
      // Arrange
      final mockAuthStateStream = Stream<User?>.fromIterable([mockUser]);
      when(mockAuth.authStateChanges()).thenAnswer((_) => mockAuthStateStream);
      
      // Act
      final result = authService.authStateChanges();
      
      // Assert
      expect(result, isA<Stream<User?>>());
      verify(mockAuth.authStateChanges()).called(1);
    });
  });
}
