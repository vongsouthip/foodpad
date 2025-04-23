import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/home/bookmark_screen.dart';
import 'package:foodpad/app/modules/home/home.dart';
import 'package:foodpad/app/modules/home/profile_screen.dart';
import 'package:foodpad/app/modules/home/search_screen.dart';

class MainNavScreen extends StatefulWidget {
  @override
  _MainNavScreenState createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: HomePage()),
    Center(child: SearchScreen()),
    Center(child: BookmarkScreen()),
    // Center(child: buildMyRecipes()),
    Center(child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react, // แบบลอยขึ้น
        backgroundColor: CustomColors.mainColor,
        color: CustomColors.fillColor,
        activeColor: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.bookmark, title: 'bookmark'),
          // TabItem(icon: Icons.notifications, title: 'Notify'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
