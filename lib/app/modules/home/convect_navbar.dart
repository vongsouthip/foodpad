import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:foodpad/app/modules/add_menu_page_view/my_menu_page.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/home/home.dart';
import 'package:foodpad/app/modules/home/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  @override
  _MainNavScreenState createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Center(child: Text("Search")),
    Center(child: Text('bookmark'),),
    Center(child: HomePage()),
    Center(child: buildMyRecipes()),
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
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.bookmark, title: 'bookmark'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.notifications, title: 'Notify'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 2,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
