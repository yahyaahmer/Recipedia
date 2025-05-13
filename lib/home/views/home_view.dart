import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../recipes/widgets/recipe_card.dart';
import '../../recipes/bloc/recipe_bloc.dart';
import '../../recipes/bloc/recipe_event.dart';
import '../../recipes/bloc/recipe_state.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/bloc/auth_event.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch recipes when the view is initialized
    _fetchRecipesForCurrentTab(0);

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchRecipesForCurrentTab(_tabController.index);
      }
    });
  }

  void _fetchRecipesForCurrentTab(int tabIndex) {
    final recipeBloc = context.read<RecipeBloc>();

    switch (tabIndex) {
      case 0: // For You tab
        recipeBloc.add(FetchRecipes());
        break;
      case 1: // Popular tab
        recipeBloc.add(FetchPopularRecipes());
        break;
      case 2: // Following tab
        // Get current user ID from AuthBloc
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated && authState.user != null) {
          recipeBloc.add(FetchUserRecipes(userId: authState.user!.uid));
        }
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to login screen when user logs out
          Navigator.of(context).pushReplacementNamed('/auth');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Diary'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Show search functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            // Dispatch logout event
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
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
            BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipesLoaded) {
                  final recipes = state.recipes;
                  if (recipes.isEmpty) {
                    return const Center(child: Text('No recipes found'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: recipes.length,
                    itemBuilder:
                        (ctx, i) => RecipeCard(
                          title: recipes[i].title,
                          author: recipes[i].authorName,
                          imageUrl: recipes[i].imageUrl,
                          rating: recipes[i].rating,
                          cookTime: recipes[i].cookTime,
                          difficulty: recipes[i].difficulty,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/recipe-detail',
                              arguments: recipes[i].id,
                            );
                          },
                        ),
                  );
                } else if (state is RecipeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                    child: Text('Select a category to view recipes'),
                  );
                }
              },
            ),

            // Popular Tab
            BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipesLoaded) {
                  final recipes = state.recipes;
                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text('No popular recipes found'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: recipes.length,
                    itemBuilder:
                        (ctx, i) => RecipeCard(
                          title: recipes[i].title,
                          author: recipes[i].authorName,
                          imageUrl: recipes[i].imageUrl,
                          rating: recipes[i].rating,
                          cookTime: recipes[i].cookTime,
                          difficulty: recipes[i].difficulty,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/recipe-detail',
                              arguments: recipes[i].id,
                            );
                          },
                        ),
                  );
                } else if (state is RecipeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                    child: Text('Select a category to view recipes'),
                  );
                }
              },
            ),

            // Following Tab
            BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipesLoaded) {
                  final recipes = state.recipes;
                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text('No recipes from people you follow'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: recipes.length,
                    itemBuilder:
                        (ctx, i) => RecipeCard(
                          title: recipes[i].title,
                          author: recipes[i].authorName,
                          imageUrl: recipes[i].imageUrl,
                          rating: recipes[i].rating,
                          cookTime: recipes[i].cookTime,
                          difficulty: recipes[i].difficulty,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/recipe-detail',
                              arguments: recipes[i].id,
                            );
                          },
                        ),
                  );
                } else if (state is RecipeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                    child: Text('Select a category to view recipes'),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/add-recipe');
          },
          tooltip: 'Add Recipe',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
