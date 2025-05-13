import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileImageUrl;
  final String coverImageUrl;
  final List<String> followers;
  final List<String> following;
  final List<String> savedRecipes;
  final DateTime createdAt;
  final DateTime lastUpdated;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.bio = '',
    this.profileImageUrl = '',
    this.coverImageUrl = '',
    required this.followers,
    required this.following,
    required this.savedRecipes,
    required this.createdAt,
    required this.lastUpdated,
  });

  // Create a UserProfile from a Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserProfile(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      savedRecipes: List<String>.from(data['savedRecipes'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  // Convert a UserProfile to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'followers': followers,
      'following': following,
      'savedRecipes': savedRecipes,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // Create a copy of the user profile with updated fields
  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? bio,
    String? profileImageUrl,
    String? coverImageUrl,
    List<String>? followers,
    List<String>? following,
    List<String>? savedRecipes,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
