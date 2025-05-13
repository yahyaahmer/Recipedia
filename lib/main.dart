import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'auth/bloc/auth_bloc.dart';
import 'recipes/bloc/recipe_bloc.dart';
import 'food_diary/bloc/diary_bloc.dart';
import 'profile/bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<RecipeBloc>(create: (context) => RecipeBloc()),
        BlocProvider<DiaryBloc>(create: (context) => DiaryBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: const FoodDiaryApp(),
    ),
  );
}
