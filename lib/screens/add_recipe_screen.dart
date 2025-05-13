import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _ingredients = [{'amount': '', 'name': ''}];
  List<String> _steps = [''];
  String _difficulty = 'Easy';
  
  void _addIngredient() {
    setState(() {
      _ingredients.add({'amount': '', 'name': ''});
    });
  }
  
  void _removeIngredient(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        _ingredients.removeAt(index);
      });
    }
  }
  
  void _addStep() {
    setState(() {
      _steps.add('');
    });
  }
  
  void _removeStep(int index) {
    if (_steps.length > 1) {
      setState(() {
        _steps.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Recipe'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save recipe and navigate back
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'PUBLISH',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Add image picker functionality
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Add Cover Photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _difficulty,
                      decoration: InputDecoration(
                        labelText: 'Difficulty',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: ['Easy', 'Medium', 'Hard'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _difficulty = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton.icon(
                    onPressed: _addIngredient,
                    icon: Icon(Icons.add),
                    label: Text('Add Ingredient'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ..._ingredients.asMap().entries.map((entry) {
                int idx = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            _ingredients[idx]['amount'] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Ingredient',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            _ingredients[idx]['name'] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton.icon(
                    onPressed: _addStep,
                    icon: Icon(Icons.add),
                    label: Text('Add Step'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ..._steps.asMap().entries.map((entry) {
                int idx = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10, top: 12),
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
                          decoration: InputDecoration(
                            labelText: 'Step ${idx + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 2,
                          onChanged: (value) {
                            _steps[idx] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
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
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
