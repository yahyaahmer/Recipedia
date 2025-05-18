import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  final String id;
  final String recipeId;
  final String recipeTitle;
  final String userId;
  final String username;
  final String userImageUrl;
  final int rating;
  final String comment;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> likes;

  Experience({
    required this.id,
    required this.recipeId,
    required this.recipeTitle,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.imageUrl,
    required this.createdAt,
    required this.likes,
  });

  // Create an Experience from a Firestore document
  factory Experience.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Experience(
      id: doc.id,
      recipeId: data['recipeId'] ?? '',
      recipeTitle: data['recipeTitle'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userImageUrl: data['userImageUrl'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  // Convert an Experience to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'comment': comment,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
    };
  }

  // Create a copy of the experience with updated fields
  Experience copyWith({
    String? id,
    String? recipeId,
    String? recipeTitle,
    String? userId,
    String? username,
    String? userImageUrl,
    int? rating,
    String? comment,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? likes,
  }) {
    return Experience(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }
}
