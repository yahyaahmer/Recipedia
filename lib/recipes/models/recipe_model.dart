import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String imageUrl;
  final String cookTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  final int ratingCount;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.imageUrl,
    required this.cookTime,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
  });

  // Create a Recipe from a Firestore document
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cookTime: data['cookTime'] ?? '',
      difficulty: data['difficulty'] ?? 'Easy',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert a Recipe to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'cookTime': cookTime,
      'difficulty': difficulty,
      'ingredients': ingredients,
      'steps': steps,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a copy of the recipe with updated fields
  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? authorId,
    String? authorName,
    String? imageUrl,
    String? cookTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
    double? rating,
    int? ratingCount,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      imageUrl: imageUrl ?? this.imageUrl,
      cookTime: cookTime ?? this.cookTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
