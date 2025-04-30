import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/home_controller.dart';
import 'package:foodpad/app/modules/home/menu_detail.dart';
import 'package:get/get.dart';

Widget buildRecipeCard() {
  final controller = Get.find<HomeController>();
  return Obx(
    () => Column(
      children:
          controller.mostLikedRecipes.map((recipe) {
            return GestureDetector(
              onTap: () {
                Get.to(() => MenuDetail(), arguments: recipe)!.then((_) {
                  controller.fetchMostLikedRecipes();
                });
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
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
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
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                recipe['likesCount'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
