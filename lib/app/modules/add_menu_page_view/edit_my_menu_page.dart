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
                    spacing: 10,
                    runSpacing: 10,
                    needsLongPressDraggable: false, // drag ได้เลย
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
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Cooking Time (min)",
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children: List.generate(controller.ingredients.length, (index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: controller.ingredients[index],
                          onChanged:
                              (val) => controller.ingredients[index] = val,
                          decoration: const InputDecoration(
                            hintText: "Ingredient",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.ingredients.removeAt(index),
                      ),
                    ],
                  );
                }),
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
                children: List.generate(controller.directions.length, (index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: controller.directions[index],
                          onChanged:
                              (val) => controller.directions[index] = val,
                          decoration: const InputDecoration(hintText: "Step"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.directions.removeAt(index),
                      ),
                    ],
                  );
                }),
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
