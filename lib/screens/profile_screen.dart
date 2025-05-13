import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://source.unsplash.com/random/1080x400/?food,cooking',
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
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage('https://source.unsplash.com/random/200x200/?portrait'),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alex Johnson',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '@alexj',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Food enthusiast and home cook. Love experimenting with new flavors!',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('Recipes', '24'),
                        _buildStatColumn('Followers', '1.2K'),
                        _buildStatColumn('Following', '384'),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'My Recipes'),
                    Tab(text: 'Experiences'),
                    Tab(text: 'Saved'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // My Recipes Tab
            GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 10,
              itemBuilder: (ctx, i) => RecipeCard(
                title: 'Homemade Pasta',
                author: 'Alex Johnson',
                imageUrl: 'https://source.unsplash.com/random/400x300/?pasta',
                rating: 4.7,
                cookTime: '45 min',
                difficulty: 'Medium',
                onTap: () {
                  Navigator.of(context).pushNamed('/recipe-detail');
                },
                isCompact: true,
              ),
            ),
            
            // Experiences Tab
            ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: 5,
              itemBuilder: (ctx, i) => Card(
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://source.unsplash.com/random/200x200/?portrait'),
                      ),
                      title: Text('Alex Johnson'),
                      subtitle: Text('Tried Chocolate Chip Cookies'),
                      trailing: Text('2d ago'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            color: Theme.of(context).highlightColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'These cookies turned out amazing! I added some walnuts for extra crunch.',
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        'https://source.unsplash.com/random/800x600/?cookies',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.favorite_border),
                            label: Text('24'),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.comment_outlined),
                            label: Text('5'),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.share),
                            label: Text('Share'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Saved Tab
            GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 8,
              itemBuilder: (ctx, i) => RecipeCard(
                title: 'Beef Wellington',
                author: 'Gordon Ramsay',
                imageUrl: 'https://source.unsplash.com/random/400x300/?beef',
                rating: 4.9,
                cookTime: '120 min',
                difficulty: 'Hard',
                onTap: () {
                  Navigator.of(context).pushNamed('/recipe-detail');
                },
                isCompact: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
