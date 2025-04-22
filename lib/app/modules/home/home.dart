import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodpad/app/controller/edit_profile_controller.dart';
import 'package:foodpad/app/modules/home/add_menu.dart';
import 'package:foodpad/app/modules/home/home_widget.dart';
import 'package:foodpad/app/modules/home/profile_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final editProfileCtrl = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  children: [
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          Get.to(ProfileScreen());
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              editProfileCtrl.profileImage.value.isNotEmpty
                                  ? NetworkImage(
                                    editProfileCtrl.profileImage.value,
                                  )
                                  : null,
                          child:
                              editProfileCtrl.profileImage.value.isEmpty
                                  ? Icon(Icons.person, size: 20)
                                  : null,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, size: 30),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'What do you want to cook today?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Category scroll
              Container(
                height: 60,
                padding: const EdgeInsets.only(left: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryChip('Breakfast', '🍞'),
                    categoryChip('Lunch', '🍔'),
                    categoryChip('Dinner', '🍟'),
                    categoryChip('Snacks', '🍟'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular Recipes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              buildRecipeCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddMenu());
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

Widget categoryChip(String label, String emoji) {
  return Container(
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFDFF5F2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: 18)),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
