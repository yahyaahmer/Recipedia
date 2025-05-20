import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rating Calculation Tests', () {
    test('Calculate average rating correctly', () {
      // Initial recipe data
      double currentRating = 4.0;
      int ratingCount = 5;
      
      // New rating
      double newRating = 5.0;
      
      // Calculate new average rating
      double totalRating = currentRating * ratingCount;
      totalRating += newRating;
      ratingCount += 1;
      double averageRating = totalRating / ratingCount;
      
      // Verify calculation
      // (4.0 * 5 + 5.0) / 6 = 25 / 6 = 4.166...
      expect(averageRating, closeTo(4.167, 0.001));
    });
    
    test('Calculate average rating for first rating', () {
      // Initial recipe data (no ratings yet)
      double currentRating = 0.0;
      int ratingCount = 0;
      
      // First rating
      double newRating = 4.5;
      
      // Calculate new average rating
      double totalRating = currentRating * ratingCount;
      totalRating += newRating;
      ratingCount += 1;
      double averageRating = totalRating / ratingCount;
      
      // Verify calculation
      expect(averageRating, 4.5);
    });
  });
}
