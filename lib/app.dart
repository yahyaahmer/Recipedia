import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/themes/app_theme.dart';
import 'auth/auth_screen.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'home/home_screen.dart';
import 'recipes/views/recipe_detail_view.dart';
import 'recipes/views/add_recipe_view.dart';
import 'profile/profile_screen.dart';
import 'food_diary/views/add_experience_view.dart';

class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Diary',
      theme: AppTheme.lightTheme,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        '/auth': (ctx) => AuthScreen(),
        '/home': (ctx) => HomeScreen(),
        '/recipe-detail': (ctx) => RecipeDetailView(),
        '/add-recipe': (ctx) => AddRecipeView(),
        '/profile': (ctx) => ProfileScreen(),
        '/add-experience': (ctx) => AddExperienceView(),
      },
    );
  }
}
