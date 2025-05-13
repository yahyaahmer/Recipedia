import 'package:flutter/material.dart';
import '../shared/widgets/bottom_nav.dart';
import 'views/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileView(),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }
}
