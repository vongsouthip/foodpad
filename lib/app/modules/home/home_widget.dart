import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodpad/app/controller/home_controller.dart';
import 'package:get/get.dart';

Widget buildRecipeCard() {
  final controller = Get.put(HomeController());
  return Obx(
    () => Column(
      children:
          controller.mostLikedRecipes.map((recipe) {
            return GestureDetector(
              onTap: () async {
                final result = await Get.toNamed('/menu_detail', arguments: recipe);
                if (result == true) {
                  controller.fetchMostLikedRecipes();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(recipe['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 250,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${recipe['cookingTime']} min",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              recipe['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              recipe['likesCount'].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    ),
  );
}
