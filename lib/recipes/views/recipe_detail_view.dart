import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../food_diary/widgets/experience_card.dart';
import '../../food_diary/bloc/diary_bloc.dart';
import '../../food_diary/bloc/diary_event.dart';
import '../../food_diary/bloc/diary_state.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({super.key});

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the recipe ID from the route arguments
    final recipeId = ModalRoute.of(context)?.settings.arguments as String?;
    if (recipeId != null) {
      // Fetch recipe details
      context.read<RecipeBloc>().add(FetchRecipeDetail(recipeId: recipeId));

      // Fetch experiences for this recipe
      context.read<DiaryBloc>().add(FetchRecipeExperiences(recipeId: recipeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is RecipeDetailLoaded) {
          final recipe = state.recipe;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(recipe.title),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://source.unsplash.com/random/800x600/?food',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(178), // 0.7 opacity
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                    IconButton(icon: const Icon(Icons.share), onPressed: () {}),
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
                                  const SizedBox(width: 10),
                                  Text(
                                    recipe.authorName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).highlightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Follow'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildInfoItem(
                                context,
                                Icons.star,
                                recipe.rating.toStringAsFixed(1),
                                'Rating',
                              ),
                              buildInfoItem(
                                context,
                                Icons.access_time,
                                recipe.cookTime,
                                'Cook Time',
                              ),
                              buildInfoItem(
                                context,
                                Icons.restaurant,
                                recipe.difficulty,
                                'Difficulty',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Ingredients',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          ...recipe.ingredients.map(
                            (ingredient) =>
                                buildIngredientItem(context, '', ingredient),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Instructions',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 10),
                          ...recipe.steps.asMap().entries.map(
                            (entry) => buildInstructionStep(
                              context,
                              entry.key + 1,
                              entry.value,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Experiences section
                          BlocBuilder<DiaryBloc, DiaryState>(
                            builder: (context, state) {
                              int experienceCount = 0;
                              if (state is ExperiencesLoaded) {
                                experienceCount = state.experiences.length;
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Experiences ($experienceCount)',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        '/add-experience',
                                        arguments: recipe.id,
                                      );
                                    },
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text('Add Your Experience'),
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),

                          // Display experiences
                          BlocBuilder<DiaryBloc, DiaryState>(
                            builder: (context, state) {
                              if (state is DiaryLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is ExperiencesLoaded) {
                                final experiences = state.experiences;
                                if (experiences.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'No experiences yet. Be the first to share!',
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children:
                                      experiences
                                          .map(
                                            (experience) => ExperienceCard(
                                              username: experience.username,
                                              rating: experience.rating,
                                              comment: experience.comment,
                                              imageUrl: experience.imageUrl,
                                              userImageUrl:
                                                  experience.userImageUrl,
                                              date:
                                                  '2 days ago', // TODO: Calculate actual date
                                            ),
                                          )
                                          .toList(),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed('/add-experience', arguments: recipe.id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.restaurant),
                        label: const Text('I Made This!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is RecipeError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Select a recipe to view details')),
          );
        }
      },
    );
  }

  Widget buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget buildIngredientItem(BuildContext context, String amount, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(name),
        ],
      ),
    );
  }

  Widget buildInstructionStep(
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
            margin: const EdgeInsets.only(right: 10, top: 2),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
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
