import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class AddRecipeView extends StatefulWidget {
  const AddRecipeView({Key? key}) : super(key: key);
  
  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [TextEditingController()];
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  String _difficulty = 'Easy';
  String? _imageUrl; // In a real app, this would be set by an image picker
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cookTimeController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }
  
  void _removeIngredient(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }
  
  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }
  
  void _removeStep(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        _stepControllers[index].dispose();
        _stepControllers.removeAt(index);
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Get values from controllers
      List<String> ingredients = _ingredientControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      
      List<String> steps = _stepControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();
      
      // Use RecipeBloc to add the recipe
      context.read<RecipeBloc>().add(
        AddRecipe(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          cookTime: _cookTimeController.text.trim(),
          difficulty: _difficulty,
          ingredients: ingredients,
          steps: steps,
          imageUrl: _imageUrl ?? 'https://source.unsplash.com/random/400x300/?food',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Recipe added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back after successful addition
          Navigator.of(context).pop();
        } else if (state is RecipeError) {
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
          appBar: AppBar(
            title: Text('Add New Recipe'),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Image
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Image picker logic would go here
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                                SizedBox(height: 10),
                                Text('Add Recipe Photo'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Recipe Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Recipe Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      
                      // Recipe Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 15),
                      
                      // Cook Time
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cookTimeController,
                              decoration: InputDecoration(
                                labelText: 'Cook Time (minutes)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _difficulty,
                              decoration: InputDecoration(
                                labelText: 'Difficulty',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: ['Easy', 'Medium', 'Hard']
                                  .map((label) => DropdownMenuItem(
                                        value: label,
                                        child: Text(label),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _difficulty = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Ingredients
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 10),
                      ..._ingredientControllers.asMap().entries.map((entry) {
                        int idx = entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: entry.value,
                                  decoration: InputDecoration(
                                    labelText: 'Ingredient ${idx + 1}',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (idx == 0 && (value == null || value.isEmpty)) {
                                      return 'Add at least one ingredient';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () => _removeIngredient(idx),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      TextButton.icon(
                        onPressed: _addIngredient,
                        icon: Icon(Icons.add),
                        label: Text('Add Ingredient'),
                      ),
                      SizedBox(height: 20),
                      
                      // Steps
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 10),
                      ..._stepControllers.asMap().entries.map((entry) {
                        int idx = entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10, top: 20),
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    (idx + 1).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: entry.value,
                                  decoration: InputDecoration(
                                    labelText: 'Step ${idx + 1}',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  maxLines: 2,
                                  validator: (value) {
                                    if (idx == 0 && (value == null || value.isEmpty)) {
                                      return 'Add at least one step';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () => _removeStep(idx),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      TextButton.icon(
                        onPressed: _addStep,
                        icon: Icon(Icons.add),
                        label: Text('Add Step'),
                      ),
                      SizedBox(height: 30),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('SAVE RECIPE', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is RecipeLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
