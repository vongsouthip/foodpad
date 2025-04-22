import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpad/app/controller/menu_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

class MyRecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final String docId;
  final controller = Get.find<MyRecipesController>();

  MyRecipeDetailScreen({required this.recipe, required this.docId});

  final titleCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleCtrl.text = recipe['title'] ?? '';
    timeCtrl.text = recipe['cookingTime']?.toString() ?? '';
    controller.loadRecipeDetail(
      recipe,
    ); // โหลด imageUrls, ingredients, directions

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Recipe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed:
                () => Get.defaultDialog(
                  title: "Delete Recipe",
                  middleText: "Are you sure?",
                  onConfirm: () => controller.deleteRecipe(docId),
                  onCancel: () => Get.back(),
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Images
            const Text("Images", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReorderableWrap(
                    spacing: 10, //space ระหว่างรูป
                    runSpacing: 10,
                    needsLongPressDraggable: false, // drag dont long press
                    onReorder: (oldIndex, newIndex) async {
                      final moved = controller.imageUrls.removeAt(oldIndex);
                      controller.imageUrls.insert(newIndex, moved);

                      await FirebaseFirestore.instance
                          .collection('recipes')
                          .doc(docId)
                          .update({'images': controller.imageUrls});
                    },
                    children: List.generate(controller.imageUrls.length, (
                      index,
                    ) {
                      final image = controller.imageUrls[index];
                      return Stack(
                        key: ValueKey(image),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: InteractiveViewer(
                                    child: Image.network(image),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed:
                                  () => controller.pickAndReplaceImage(
                                    index,
                                    docId,
                                  ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                controller.imageUrls.removeAt(index);
                                FirebaseFirestore.instance
                                    .collection('recipes')
                                    .doc(docId)
                                    .update({'images': controller.imageUrls});
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => controller.addNewImage(docId),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Image"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: "Enter title...",
                filled: true,
                fillColor: CustomColors.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Cooking time",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: timeCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Cooking time (min)",
                filled: true,
                fillColor: CustomColors.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.ingredients.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: controller.ingredients[index],
                              onChanged:
                                  (val) => controller.ingredients[index] = val,
                              decoration: InputDecoration(
                                hintText: "ingredient",
                                filled: true,
                                fillColor: CustomColors.fillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => controller.ingredients.removeAt(
                                        index,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.ingredients.add(""),
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
            ),

            const SizedBox(height: 20),
            const Text(
              "Directions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.directions.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: controller.directions[index],
                              onChanged:
                                  (val) => controller.directions[index] = val,
                              decoration: InputDecoration(
                                hintText: "Direction",
                                filled: true,
                                fillColor: CustomColors.fillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () =>
                                          controller.directions.removeAt(index),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.directions.add(""),
              icon: const Icon(Icons.add),
              label: const Text("Add Step"),
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed:
                  () => controller.updateFullRecipe(
                    docId: docId,
                    title: titleCtrl.text,
                    cookingTime: timeCtrl.text,
                  ),
              label: const Text(
                "Save Changes",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: CustomColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
