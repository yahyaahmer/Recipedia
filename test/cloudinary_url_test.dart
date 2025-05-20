import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cloudinary URL Tests', () {
    test('Extract public ID from Cloudinary URL', () {
      // Test Cloudinary URL
      final url =
          'https://res.cloudinary.com/dw2mqwsaw/image/upload/v1234567890/recipes/user123/image.jpg';

      // Parse the URL
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Find the 'upload' segment
      final uploadIndex = pathSegments.indexOf('upload');

      // Extract the public ID (everything after 'upload')
      final publicId =
          uploadIndex != -1 && uploadIndex < pathSegments.length - 1
              ? pathSegments
                  .sublist(uploadIndex + 2)
                  .join('/') // Skip 'upload' and version segment
              : '';

      // Verify extraction
      expect(publicId, 'recipes/user123/image.jpg');
    });

    test('Validate Cloudinary URL format', () {
      // Valid Cloudinary URL
      final validUrl =
          'https://res.cloudinary.com/dw2mqwsaw/image/upload/v1234567890/recipes/user123/image.jpg';

      // Invalid URL
      final invalidUrl = 'https://example.com/image.jpg';

      // Parse and validate the URLs
      final validUri = Uri.parse(validUrl);
      final invalidUri = Uri.parse(invalidUrl);

      final isValidCloudinaryUrl =
          validUri.host.contains('cloudinary.com') &&
          validUri.pathSegments.contains('upload');

      final isInvalidCloudinaryUrl =
          invalidUri.host.contains('cloudinary.com') &&
          invalidUri.pathSegments.contains('upload');

      // Verify validation
      expect(isValidCloudinaryUrl, true);
      expect(isInvalidCloudinaryUrl, false);
    });
  });
}
