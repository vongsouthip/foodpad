import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class MyRecipesController extends GetxController {
  var recipes = [].obs;
  var isLoading = false.obs;
  var imageUrls = <String>[].obs;
  var ingredients = <String>[].obs;
  var directions = <String>[].obs;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchMyRecipes();
  }
  /// ✅ โหลดเฉพาะเมนูของผู้ใช้ปัจจุบัน
  Future<void> fetchMyRecipes() async {
    isLoading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        recipes.clear();
        isLoading.value = false;
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('recipes')
              .where('uid', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .get();

      recipes.value =
          snapshot.docs
              .map(
                (doc) => {
                  ...doc.data(),
                  'id': doc.id, // แนบ docId มาด้วย
                },
              )
              .toList();
    } catch (e) {
      print('Error fetching recipes: $e');
    }
    isLoading.value = false;
  }

  /// ✅ ลบเมนู
  Future<void> deleteRecipe(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(docId)
          .delete();
      fetchMyRecipes();
      Get.back(result: true);
      Get.snackbar("Deleted", "Recipe has been deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete recipe");
    }
  }

  /// ✅ เปลี่ยนรูปภาพและอัปโหลดขึ้น Cloudinary
  Future<void> pickAndReplaceImage(int index, String docId) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path),
      'upload_preset': 'code camp',
    });

    final response = await dio.Dio().post(
      'https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      final url = response.data['secure_url'];
      imageUrls[index] = url;

      await FirebaseFirestore.instance.collection('recipes').doc(docId).update({
        'images': imageUrls,
      });

      Get.snackbar("Updated", "Image replaced successfully");
    } else {
      Get.snackbar("Error", "Image upload failed");
    }
  }

  Future<void> addNewImage(String docId) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path),
      'upload_preset': 'code camp',
    });

    final response = await dio.Dio().post(
      'https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      final url = response.data['secure_url'];
      imageUrls.add(url);

      await FirebaseFirestore.instance.collection('recipes').doc(docId).update({
        'images': imageUrls,
      });
      Get.snackbar("Image Added", "New image added successfully");
    }
  }

  /// ✅ โหลด ingredients/directions สำหรับแก้ไข
  void loadRecipeDetail(Map<String, dynamic> recipe) {
    imageUrls.value = List<String>.from(recipe['images'] ?? []);
    ingredients.value = List<String>.from(recipe['ingredients'] ?? []);
    directions.value = List<String>.from(recipe['directions'] ?? []);
  }

  /// ✅ อัปเดตเมนูพร้อม ingredients และ directions
  Future<void> updateFullRecipe({
    required String docId,
    required String title,
    required String cookingTime,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('recipes').doc(docId).update({
        'title': title.trim(),
        'cookingTime': int.tryParse(cookingTime.trim()) ?? 0,
        'ingredients': ingredients,
        'directions': directions,
      });
      fetchMyRecipes();
      Get.back(result: true);
      Get.snackbar("Success", "Recipe updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update recipe");
    }
  }
}
