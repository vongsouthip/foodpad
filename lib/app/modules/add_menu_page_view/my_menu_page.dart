import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/menu_controller.dart';
import 'package:foodpad/app/modules/add_menu_page_view/edit_my_menu_page.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

Widget buildMyRecipes() {
  final controller = Get.put(MyRecipesController());
  return Obx(() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.recipes.isEmpty) {
      return const Center(child: Text("No recipes found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: controller.recipes.length,
      itemBuilder: (context, index) {
        final recipe = controller.recipes[index];
        final imageUrl =
            (recipe['images'] != null && recipe['images'].isNotEmpty)
                ? recipe['images'][0]
                : null;

        return GestureDetector(
          onTap: () {
            Get.to(
              () => MyRecipeDetailScreen(
                recipe: controller.recipes[index],
                docId: controller.recipes[index]['id'],
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  imageUrl != null
                      ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: imageUrl == null ? Colors.grey[300] : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: StrokeText(
                    text: recipe['title'] ?? '',
                    strokeColor: Colors.black,
                    strokeWidth: 5,
                    maxLines: 2,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (recipe['cookingTime'] != null)
                  Positioned(
                    bottom: 60,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 10,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${recipe['cookingTime']} min",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  });
}
