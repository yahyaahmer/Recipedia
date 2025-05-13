import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _recipesCollection => _firestore.collection('recipes');
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get all recipes
  Stream<List<Recipe>> getRecipes() {
    return _recipesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }
  
  // Get popular recipes
  Stream<List<Recipe>> getPopularRecipes() {
    return _recipesCollection
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }
  
  // Get recipes by user
  Stream<List<Recipe>> getUserRecipes(String userId) {
    return _recipesCollection
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }
  
  // Get recipe by ID
  Future<Recipe?> getRecipeById(String recipeId) async {
    DocumentSnapshot doc = await _recipesCollection.doc(recipeId).get();
    if (doc.exists) {
      return Recipe.fromFirestore(doc);
    }
    return null;
  }
  
  // Add a new recipe
  Future<String> addRecipe({
    required String title,
    required String description,
    required String imageUrl,
    required String cookTime,
    required String difficulty,
    required List<String> ingredients,
    required List<String> steps,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get current user's display name
    String authorName = _auth.currentUser?.displayName ?? 'Anonymous';
    
    // Create recipe data
    Map<String, dynamic> recipeData = {
      'title': title,
      'description': description,
      'authorId': currentUserId,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'cookTime': cookTime,
      'difficulty': difficulty,
      'ingredients': ingredients,
      'steps': steps,
      'rating': 0.0,
      'ratingCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    };
    
    // Add to Firestore
    DocumentReference docRef = await _recipesCollection.add(recipeData);
    return docRef.id;
  }
  
  // Update a recipe
  Future<void> updateRecipe({
    required String recipeId,
    String? title,
    String? description,
    String? imageUrl,
    String? cookTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get the recipe to check ownership
    DocumentSnapshot doc = await _recipesCollection.doc(recipeId).get();
    if (!doc.exists) {
      throw Exception('Recipe not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['authorId'] != currentUserId) {
      throw Exception('You do not have permission to update this recipe');
    }
    
    // Create update data
    Map<String, dynamic> updateData = {};
    if (title != null) updateData['title'] = title;
    if (description != null) updateData['description'] = description;
    if (imageUrl != null) updateData['imageUrl'] = imageUrl;
    if (cookTime != null) updateData['cookTime'] = cookTime;
    if (difficulty != null) updateData['difficulty'] = difficulty;
    if (ingredients != null) updateData['ingredients'] = ingredients;
    if (steps != null) updateData['steps'] = steps;
    
    // Update in Firestore
    await _recipesCollection.doc(recipeId).update(updateData);
  }
  
  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get the recipe to check ownership
    DocumentSnapshot doc = await _recipesCollection.doc(recipeId).get();
    if (!doc.exists) {
      throw Exception('Recipe not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['authorId'] != currentUserId) {
      throw Exception('You do not have permission to delete this recipe');
    }
    
    // Delete from Firestore
    await _recipesCollection.doc(recipeId).delete();
  }
  
  // Update recipe rating
  Future<void> updateRecipeRating(String recipeId, double newRating) async {
    DocumentSnapshot doc = await _recipesCollection.doc(recipeId).get();
    if (!doc.exists) {
      throw Exception('Recipe not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    double currentRating = (data['rating'] ?? 0.0).toDouble();
    int ratingCount = (data['ratingCount'] ?? 0);
    
    // Calculate new average rating
    double totalRating = currentRating * ratingCount;
    totalRating += newRating;
    ratingCount += 1;
    double averageRating = totalRating / ratingCount;
    
    // Update in Firestore
    await _recipesCollection.doc(recipeId).update({
      'rating': averageRating,
      'ratingCount': ratingCount,
    });
  }
}
