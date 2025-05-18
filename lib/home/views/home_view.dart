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
  bool _isFilterExpanded = false;
  String? _currentDifficultyFilter;

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
        recipeBloc.add(
          FetchRecipes(difficultyFilter: _currentDifficultyFilter),
        );
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

  void _applyDifficultyFilter(String? difficulty) {
    setState(() {
      // If the same filter is selected again, remove it
      if (_currentDifficultyFilter == difficulty) {
        _currentDifficultyFilter = null;
      } else {
        _currentDifficultyFilter = difficulty;
      }
      _isFilterExpanded = false;
    });

    // Only apply filter to the "For You" tab
    if (_tabController.index == 0) {
      // Show loading state before fetching
      context.read<RecipeBloc>().add(RecipeErrorEvent(message: ''));
      context.read<RecipeBloc>().add(RecipesUpdated(recipes: []));

      // Fetch with filter
      _fetchRecipesForCurrentTab(0);
    }
  }

  // Build a filter option button
  Widget _buildFilterOption(String label, String value) {
    final isSelected = _currentDifficultyFilter == value;

    return InkWell(
      onTap: () => _applyDifficultyFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
          title: const Text('Recipedia'),
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
            Column(
              children: [
                // Filter section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isFilterExpanded = !_isFilterExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Filter',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Icon(
                                _isFilterExpanded
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Current filter chip (if any)
                      if (_currentDifficultyFilter != null)
                        Chip(
                          label: Text(_currentDifficultyFilter!),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted:
                              () => _applyDifficultyFilter(
                                _currentDifficultyFilter,
                              ),
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withAlpha(50),
                        ),
                      const Spacer(),
                      // Filter button
                      
                    ],
                  ),
                ),

                // Filter options (only shown when expanded)
                if (_isFilterExpanded)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Difficulty:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFilterOption('Easy', 'Easy'),
                            _buildFilterOption('Medium', 'Medium'),
                            _buildFilterOption('Hard', 'Hard'),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Recipe list
                Expanded(
                  child: BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecipesLoaded) {
                        final recipes = state.recipes;
                        if (recipes.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_currentDifficultyFilter != null)
                                  Text(
                                    'No ${_currentDifficultyFilter!} recipes found',
                                    style: const TextStyle(fontSize: 16),
                                  )
                                else
                                  const Text(
                                    'No recipes found',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 16),
                                if (_currentDifficultyFilter != null)
                                  ElevatedButton.icon(
                                    onPressed:
                                        () => _applyDifficultyFilter(
                                          _currentDifficultyFilter,
                                        ),
                                    icon: const Icon(Icons.filter_alt_off),
                                    label: const Text('Clear filter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
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
                ),
              ],
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
