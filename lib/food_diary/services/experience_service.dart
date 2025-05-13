import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/experience_model.dart';
import '../../recipes/services/recipe_service.dart';

class ExperienceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RecipeService _recipeService = RecipeService();
  
  // Collection references
  CollectionReference get _experiencesCollection => _firestore.collection('experiences');
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get all experiences
  Stream<List<Experience>> getExperiences() {
    return _experiencesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Experience.fromFirestore(doc)).toList();
    });
  }
  
  // Get experiences by recipe
  Stream<List<Experience>> getRecipeExperiences(String recipeId) {
    return _experiencesCollection
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Experience.fromFirestore(doc)).toList();
    });
  }
  
  // Get experiences by user
  Stream<List<Experience>> getUserExperiences(String userId) {
    return _experiencesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Experience.fromFirestore(doc)).toList();
    });
  }
  
  // Add a new experience
  Future<String> addExperience({
    required String recipeId,
    required String recipeTitle,
    required int rating,
    required String comment,
    required String imageUrl,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get current user's display name and profile image
    String username = _auth.currentUser?.displayName ?? 'Anonymous';
    String userImageUrl = _auth.currentUser?.photoURL ?? '';
    
    // Create experience data
    Map<String, dynamic> experienceData = {
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'userId': currentUserId,
      'username': username,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'comment': comment,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': [],
    };
    
    // Add to Firestore
    DocumentReference docRef = await _experiencesCollection.add(experienceData);
    
    // Update recipe rating
    await _recipeService.updateRecipeRating(recipeId, rating.toDouble());
    
    return docRef.id;
  }
  
  // Update an experience
  Future<void> updateExperience({
    required String experienceId,
    int? rating,
    String? comment,
    String? imageUrl,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get the experience to check ownership
    DocumentSnapshot doc = await _experiencesCollection.doc(experienceId).get();
    if (!doc.exists) {
      throw Exception('Experience not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != currentUserId) {
      throw Exception('You do not have permission to update this experience');
    }
    
    // Create update data
    Map<String, dynamic> updateData = {};
    if (rating != null) updateData['rating'] = rating;
    if (comment != null) updateData['comment'] = comment;
    if (imageUrl != null) updateData['imageUrl'] = imageUrl;
    
    // Update in Firestore
    await _experiencesCollection.doc(experienceId).update(updateData);
  }
  
  // Delete an experience
  Future<void> deleteExperience(String experienceId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get the experience to check ownership
    DocumentSnapshot doc = await _experiencesCollection.doc(experienceId).get();
    if (!doc.exists) {
      throw Exception('Experience not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != currentUserId) {
      throw Exception('You do not have permission to delete this experience');
    }
    
    // Delete from Firestore
    await _experiencesCollection.doc(experienceId).delete();
  }
  
  // Like/unlike an experience
  Future<void> toggleLike(String experienceId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    DocumentSnapshot doc = await _experiencesCollection.doc(experienceId).get();
    if (!doc.exists) {
      throw Exception('Experience not found');
    }
    
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<String> likes = List<String>.from(data['likes'] ?? []);
    
    if (likes.contains(currentUserId)) {
      // Unlike
      likes.remove(currentUserId);
    } else {
      // Like
      likes.add(currentUserId!);
    }
    
    await _experiencesCollection.doc(experienceId).update({'likes': likes});
  }
}
