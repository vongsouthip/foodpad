import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var mostLikedRecipes = RxList<Map<String, dynamic>>([]);
  var selectedCategory = ''.obs;
  StreamSubscription? recipeSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchMostLikedRecipes();
  }

  @override
  void onReady() {
    super.onReady();
    fetchMostLikedRecipes();
  }

  void changeCategory(String category) {
    selectedCategory.value = category == 'ALL' ? '' : category;
    fetchMostLikedRecipes();
  }

  Future<void> fetchMostLikedRecipes() async {
    // ยกเลิกการฟังเก่าก่อน ถ้ามี
    recipeSubscription?.cancel();

    recipeSubscription = FirebaseFirestore.instance
        .collection('recipes')
        .where(
          'category',
          isEqualTo:
              selectedCategory.value.isEmpty ? null : selectedCategory.value,
        )
        .snapshots()
        .listen((snapshot) {
          final recipes =
              snapshot.docs.map((doc) {
                final data = doc.data();
                final likes =
                    (data['likes'] is List)
                        ? List<String>.from(data['likes'])
                        : <String>[];
                return {
                  'title': data['title'] ?? '',
                  'uid': data['uid'] ?? '',
                  'images': List<String>.from(data['images'] ?? []),
                  'image':
                      (data['images'] != null && data['images'].isNotEmpty)
                          ? data['images'][0]
                          : '',
                  'likesCount': likes.length,
                  'docId': doc.id,
                  'ingredients': data['ingredients'] ?? '',
                  'directions': data['directions'] ?? '',
                  'cookingTime': data['cookingTime'] ?? '',
                  'difficulty': data['difficulty'] ?? '',
                  'category': data['category'] ?? '',
                  'createdAt': data['createdAt'] ?? '',
                };
              }).toList();

          recipes.sort((a, b) => b['likesCount'].compareTo(a['likesCount']));
          mostLikedRecipes.assignAll(recipes); // อัปเดต Obx อัตโนมัติ
        });
  }

  @override
  void onClose() {
    recipeSubscription?.cancel();
    super.onClose();
  }
}
