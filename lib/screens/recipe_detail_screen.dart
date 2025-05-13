import 'package:flutter/material.dart';
import '../widgets/experience_card.dart';

class RecipeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Homemade Pasta with Tomato Sauce'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://source.unsplash.com/random/800x600/?pasta',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
              IconButton(icon: Icon(Icons.share), onPressed: () {}),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://source.unsplash.com/random/100x100/?chef',
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Jamie Oliver',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Follow'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).highlightColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(context, Icons.star, '4.7', 'Rating'),
                        _buildInfoItem(
                          context,
                          Icons.access_time,
                          '45 min',
                          'Cook Time',
                        ),
                        _buildInfoItem(
                          context,
                          Icons.restaurant,
                          'Medium',
                          'Difficulty',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 10),
                    _buildIngredientItem(context, '400g', 'Flour'),
                    _buildIngredientItem(context, '4', 'Eggs'),
                    _buildIngredientItem(context, '1 tbsp', 'Olive Oil'),
                    _buildIngredientItem(context, '500g', 'Tomatoes'),
                    _buildIngredientItem(context, '2 cloves', 'Garlic'),
                    _buildIngredientItem(context, '1 bunch', 'Fresh Basil'),
                    SizedBox(height: 20),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 10),
                    _buildInstructionStep(
                      context,
                      1,
                      'Mix flour and eggs in a bowl until a dough forms.',
                    ),
                    _buildInstructionStep(
                      context,
                      2,
                      'Knead the dough for 10 minutes until smooth.',
                    ),
                    _buildInstructionStep(
                      context,
                      3,
                      'Rest the dough for 30 minutes covered with a cloth.',
                    ),
                    _buildInstructionStep(
                      context,
                      4,
                      'Roll out the dough and cut into desired pasta shapes.',
                    ),
                    _buildInstructionStep(
                      context,
                      5,
                      'For the sauce, sauté garlic in olive oil.',
                    ),
                    _buildInstructionStep(
                      context,
                      6,
                      'Add chopped tomatoes and simmer for 20 minutes.',
                    ),
                    _buildInstructionStep(
                      context,
                      7,
                      'Cook pasta in salted water for 2-3 minutes.',
                    ),
                    _buildInstructionStep(
                      context,
                      8,
                      'Combine pasta with sauce and garnish with basil.',
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experiences (24)',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/add-experience');
                          },
                          icon: Icon(Icons.add_photo_alternate),
                          label: Text('Add Your Experience'),
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ExperienceCard(
                      username: 'Sarah Johnson',
                      rating: 5,
                      comment:
                          'This recipe was amazing! The pasta came out perfectly al dente and the sauce was so flavorful. Will definitely make again!',
                      imageUrl:
                          'https://source.unsplash.com/random/400x300/?homemade,pasta',
                      userImageUrl:
                          'https://source.unsplash.com/random/100x100/?woman',
                      date: '2 days ago',
                    ),
                    ExperienceCard(
                      username: 'Mike Thompson',
                      rating: 4,
                      comment:
                          'Great recipe! I added some red pepper flakes for extra heat. The dough was a bit tricky to work with but the end result was worth it.',
                      imageUrl:
                          'https://source.unsplash.com/random/400x300/?pasta,plate',
                      userImageUrl:
                          'https://source.unsplash.com/random/100x100/?man',
                      date: '1 week ago',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.restaurant),
                  label: Text('I Made This!'),
                  style: ElevatedButton.styleFrom(
                    //primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildIngredientItem(
    BuildContext context,
    String amount,
    String name,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(name),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(
    BuildContext context,
    int step,
    String instruction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, top: 2),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(child: Text(instruction)),
        ],
      ),
    );
  }
}
