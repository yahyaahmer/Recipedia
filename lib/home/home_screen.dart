import 'package:flutter/material.dart';
import '../shared/widgets/bottom_nav.dart';
import 'views/home_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeView(),
      bottomNavigationBar: BottomNav(currentIndex: _currentIndex),
    );
  }
}
