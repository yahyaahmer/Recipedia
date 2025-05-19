import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class StorageService {
  // Cloudinary configuration
  // These should match your Cloudinary account settings
  final String cloudName = 'dw2mqwsaw'; // Verify this is your cloud name
  final String uploadPreset =
      'recipe_app_preset'; // Verify this preset exists and is unsigned

  late final CloudinaryPublic _cloudinary;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constructor to initialize Cloudinary
  StorageService() {
    _cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Upload an image to Cloudinary
  Future<String> uploadImage(File imageFile, String folder) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Create folder structure for organization
      final folderPath = '$folder/${currentUserId!}';

      // For debugging - log upload attempt
      print('⚠️ DEBUG: Attempting to upload image to Cloudinary');
      print('⚠️ DEBUG: Cloud name: $cloudName');
      print('⚠️ DEBUG: Upload preset: $uploadPreset');
      print('⚠️ DEBUG: Folder path: $folderPath');
      print('⚠️ DEBUG: Image file path: ${imageFile.path}');

      // Upload to Cloudinary with public_id to specify path
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: folderPath),
      );

      // For debugging - log successful upload
      print('✅ DEBUG: Image uploaded successfully to Cloudinary');
      print('✅ DEBUG: Secure URL: ${response.secureUrl}');
      print('✅ DEBUG: Public ID: ${response.publicId}');

      // Return the secure URL
      return response.secureUrl;
    } catch (e) {
      // For debugging - log upload failure
      print('❌ DEBUG: Failed to upload image to Cloudinary: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }

  // Delete an image from Cloudinary
  // Note: This requires Cloudinary Admin API which is not available in client-side code
  // You would typically implement this in your backend
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract the public ID from the URL
      // This is a simplified approach and might need adjustment based on your URL structure
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the upload folder and filename
      // Typically, Cloudinary URLs look like: https://res.cloudinary.com/cloud_name/image/upload/v1234567890/folder/filename.jpg
      int uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        // This is just a placeholder - client-side deletion is not recommended for security reasons
        // You should implement this in your backend

        // In a real app, you would call your backend API to delete the image using the public ID
        // Example: final publicId = pathSegments.sublist(uploadIndex + 1).join('/');
        // await http.delete('your-backend-url/delete-image?publicId=$publicId');
      }

      // Note: We're not actually deleting the image here since it requires Admin API
      // In a real app, you would call your backend to handle deletion
    } catch (e) {
      throw Exception('Failed to process delete request: $e');
    }
  }
}
