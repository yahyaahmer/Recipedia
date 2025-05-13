import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'For You'),
            Tab(text: 'Popular'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // For You Tab
          ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 10,
            itemBuilder: (ctx, i) => RecipeCard(
              title: 'Homemade Pasta with Tomato Sauce',
              author: 'Jamie Oliver',
              imageUrl: 'https://source.unsplash.com/random/400x300/?pasta',
              rating: 4.7,
              cookTime: '45 min',
              difficulty: 'Medium',
              onTap: () {
                Navigator.of(context).pushNamed('/recipe-detail');
              },
            ),
          ),
          
          // Popular Tab
          ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 10,
            itemBuilder: (ctx, i) => RecipeCard(
              title: 'Chocolate Chip Cookies',
              author: 'Gordon Ramsay',
              imageUrl: 'https://source.unsplash.com/random/400x300/?cookies',
              rating: 4.9,
              cookTime: '30 min',
              difficulty: 'Easy',
              onTap: () {
                Navigator.of(context).pushNamed('/recipe-detail');
              },
            ),
          ),
          
          // Following Tab
          ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: 10,
            itemBuilder: (ctx, i) => RecipeCard(
              title: 'Beef Wellington',
              author: 'Julia Child',
              imageUrl: 'https://source.unsplash.com/random/400x300/?beef',
              rating: 4.5,
              cookTime: '120 min',
              difficulty: 'Hard',
              onTap: () {
                Navigator.of(context).pushNamed('/recipe-detail');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-recipe');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
      bottomNavigationBar: BottomNav(currentIndex: 0),
    );
  }
}
