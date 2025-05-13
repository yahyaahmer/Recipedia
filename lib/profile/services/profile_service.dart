import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    DocumentSnapshot doc = await _usersCollection.doc(userId).get();
    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    }
    return null;
  }
  
  // Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    if (currentUserId == null) {
      return null;
    }
    return getUserProfile(currentUserId!);
  }
  
  // Create or update user profile
  Future<void> createOrUpdateUserProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
    String? coverImageUrl,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
    
    if (doc.exists) {
      // Update existing profile
      Map<String, dynamic> updateData = {};
      if (username != null) updateData['username'] = username;
      if (bio != null) updateData['bio'] = bio;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      if (coverImageUrl != null) updateData['coverImageUrl'] = coverImageUrl;
      updateData['lastUpdated'] = FieldValue.serverTimestamp();
      
      await _usersCollection.doc(currentUserId).update(updateData);
      
      // Update display name in Firebase Auth if username is provided
      if (username != null) {
        await _auth.currentUser?.updateDisplayName(username);
      }
      
      // Update profile photo in Firebase Auth if profileImageUrl is provided
      if (profileImageUrl != null) {
        await _auth.currentUser?.updatePhotoURL(profileImageUrl);
      }
    } else {
      // Create new profile
      String email = _auth.currentUser?.email ?? '';
      String displayName = username ?? _auth.currentUser?.displayName ?? 'User';
      
      Map<String, dynamic> userData = {
        'username': displayName,
        'email': email,
        'bio': bio ?? '',
        'profileImageUrl': profileImageUrl ?? '',
        'coverImageUrl': coverImageUrl ?? '',
        'followers': [],
        'following': [],
        'savedRecipes': [],
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };
      
      await _usersCollection.doc(currentUserId).set(userData);
      
      // Update display name in Firebase Auth if not already set
      if (_auth.currentUser?.displayName == null || _auth.currentUser?.displayName == '') {
        await _auth.currentUser?.updateDisplayName(displayName);
      }
    }
  }
  
  // Follow/unfollow a user
  Future<void> toggleFollow(String targetUserId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    if (currentUserId == targetUserId) {
      throw Exception('You cannot follow yourself');
    }
    
    // Get current user's profile
    DocumentSnapshot currentUserDoc = await _usersCollection.doc(currentUserId).get();
    if (!currentUserDoc.exists) {
      // Create profile if it doesn't exist
      await createOrUpdateUserProfile();
      currentUserDoc = await _usersCollection.doc(currentUserId).get();
    }
    
    // Get target user's profile
    DocumentSnapshot targetUserDoc = await _usersCollection.doc(targetUserId).get();
    if (!targetUserDoc.exists) {
      throw Exception('User not found');
    }
    
    // Get following list of current user
    Map<String, dynamic> currentUserData = currentUserDoc.data() as Map<String, dynamic>;
    List<String> following = List<String>.from(currentUserData['following'] ?? []);
    
    // Get followers list of target user
    Map<String, dynamic> targetUserData = targetUserDoc.data() as Map<String, dynamic>;
    List<String> followers = List<String>.from(targetUserData['followers'] ?? []);
    
    // Check if already following
    bool isFollowing = following.contains(targetUserId);
    
    if (isFollowing) {
      // Unfollow
      following.remove(targetUserId);
      followers.remove(currentUserId);
    } else {
      // Follow
      following.add(targetUserId);
      followers.add(currentUserId!);
    }
    
    // Update both users
    await _usersCollection.doc(currentUserId).update({'following': following});
    await _usersCollection.doc(targetUserId).update({'followers': followers});
  }
  
  // Save/unsave a recipe
  Future<void> toggleSaveRecipe(String recipeId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    // Get current user's profile
    DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
    if (!doc.exists) {
      // Create profile if it doesn't exist
      await createOrUpdateUserProfile();
      doc = await _usersCollection.doc(currentUserId).get();
    }
    
    // Get saved recipes list
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    List<String> savedRecipes = List<String>.from(userData['savedRecipes'] ?? []);
    
    // Check if already saved
    bool isSaved = savedRecipes.contains(recipeId);
    
    if (isSaved) {
      // Unsave
      savedRecipes.remove(recipeId);
    } else {
      // Save
      savedRecipes.add(recipeId);
    }
    
    // Update user
    await _usersCollection.doc(currentUserId).update({'savedRecipes': savedRecipes});
  }
  
  // Get saved recipes IDs
  Future<List<String>> getSavedRecipeIds() async {
    if (currentUserId == null) {
      return [];
    }
    
    DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
    if (!doc.exists) {
      return [];
    }
    
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    return List<String>.from(userData['savedRecipes'] ?? []);
  }
}
