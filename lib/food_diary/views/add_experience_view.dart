import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/diary_bloc.dart';
import '../bloc/diary_event.dart';
import '../bloc/diary_state.dart';
import '../../recipes/bloc/recipe_bloc.dart';
import '../../recipes/bloc/recipe_state.dart';
import '../../shared/services/storage_service.dart';

class AddExperienceView extends StatefulWidget {
  const AddExperienceView({Key? key}) : super(key: key);

  @override
  _AddExperienceViewState createState() => _AddExperienceViewState();
}

class _AddExperienceViewState extends State<AddExperienceView> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;
  File? _imageFile;
  bool _isUploading = false;
  String? _recipeId;
  String? _recipeTitle;
  String? _recipeAuthor;

  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the recipe ID from the route arguments
    _recipeId = ModalRoute.of(context)?.settings.arguments as String?;

    // Fetch recipe details if we have an ID
    if (_recipeId != null) {
      final recipeState = context.read<RecipeBloc>().state;
      if (recipeState is RecipeDetailLoaded) {
        setState(() {
          _recipeTitle = recipeState.recipe.title;
          _recipeAuthor = recipeState.recipe.authorName;
        });
      }
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload to Firebase Storage
      final downloadUrl = await _storageService.uploadImage(
        _imageFile!,
        'experience_images',
      );
      return downloadUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _recipeId != null &&
        _recipeTitle != null) {
      _formKey.currentState!.save();

      // Upload image if selected
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
        if (imageUrl == null && mounted) {
          // If upload failed, show error and return
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Add experience
      if (mounted) {
        context.read<DiaryBloc>().add(
          AddExperience(
            recipeId: _recipeId!,
            recipeTitle: _recipeTitle!,
            rating: _rating,
            comment: _commentController.text.trim(),
            imageUrl: imageUrl,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryBloc, DiaryState>(
      listener: (context, state) {
        if (state is ExperienceAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your experience has been shared!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is DiaryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Share Your Experience')),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Title
                      Text(
                        _recipeTitle ?? 'Loading recipe details...',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 5),
                      Text(
                        _recipeAuthor != null ? 'by $_recipeAuthor' : '',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),

                      // Rating
                      Text(
                        'Your Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Theme.of(context).highlightColor,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Comment
                      Text(
                        'Your Comment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Share your experience with this recipe...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please share your thoughts';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Photo
                      Text(
                        'Add Photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                            image:
                                _imageFile != null
                                    ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              _imageFile == null
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text('Add Photo of Your Result'),
                                    ],
                                  )
                                  : _isUploading
                                  ? Center(child: CircularProgressIndicator())
                                  : Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      // This is an empty container to maintain the stack
                                      Container(),
                                      // Remove image button
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 18,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _imageFile = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is DiaryLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'SHARE EXPERIENCE',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is DiaryLoading)
                Container(
                  color: Colors.black.withAlpha(76), // 0.3 opacity
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
