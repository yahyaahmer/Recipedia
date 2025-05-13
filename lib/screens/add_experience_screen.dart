import 'package:flutter/material.dart';

class AddExperienceScreen extends StatefulWidget {
  @override
  _AddExperienceScreenState createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 4.0;
  List<String> _images = [];
  
  void _addImage() {
    // In a real app, this would open image picker
    setState(() {
      _images.add('https://source.unsplash.com/random/400x300/?food,cooking');
    });
  }
  
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Your Experience'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save experience and navigate back
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'POST',
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
              Text(
                'Rate this recipe',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _rating.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 8,
                      label: _rating.toString(),
                      onChanged: (double value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Share your photos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              Container(
                height: 120,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _addImage,
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (ctx, i) => Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(_images[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 15,
                              child: GestureDetector(
                                onTap: () => _removeImage(i),
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Write your review',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Share your experience with this recipe...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Did you make any modifications?',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Share any changes or substitutions you made...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
