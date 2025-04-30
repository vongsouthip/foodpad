// ✅ AddMenuController.dart - Save images to Cloudinary
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpad/app/controller/menu_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;

class AddMenuController extends GetxController {
  var currentStep = 0.obs;

  // Step 1: Title & Images
  var recipeTitle = ''.obs;
  var recipeImages = <File>[].obs;

  // Step 2: Info
  var cookingTime = 0.obs;
  var difficulty = ''.obs;
  var category = ''.obs;

  // Step 3: Ingredients
  var ingredients = <String>[].obs;

  // Step 4: Directions
  var directions = <String>[].obs;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    resetForm();
  }

  //ใช้ image_picker เพื่อเลือกรูปภาพหลายรูปในคราวเดียว แล้วเก็บไว้ใน recipeImages (เป็น List<File>)
  void pickImage() async {
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      recipeImages.addAll(picked.map((e) => File(e.path)));
    }
  }

  void addIngredientField() {
    ingredients.add("");
  }

  void addDirectionField() {
    directions.add("");
  }

  Future<List<String>> uploadImagesToCloudinary() async {
    List<String> urls = [];
    final dioInstance = dio.Dio();

    for (var image in recipeImages) {
      final fileName = image.path.split('/').last;
      final formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
        "upload_preset": "code camp",
      });

      try {
        final response = await dioInstance.post(
          "https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload",
          data: formData,
        );

        if (response.statusCode == 200) {
          urls.add(response.data['secure_url']);
        }
      } catch (e) {
        print("Cloudinary upload failed: $e");
      }
    }
    return urls;
  }

  Future<void> submitRecipe() async {
    final imageUrls = await uploadImagesToCloudinary();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('recipes').add({
      'uid': uid,
      'title': recipeTitle.value,
      'images': imageUrls,
      'cookingTime': cookingTime.value,
      'difficulty': difficulty.value,
      'category': category.value,
      'ingredients': ingredients,
      'directions': directions,
      'likes': [],
      'bookmarkedBy': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    Get.find<MyRecipesController>().fetchMyRecipes();
    resetForm();
  }

  void resetForm() {
    currentStep.value = 0;
    recipeTitle.value = '';
    recipeImages.clear();
    cookingTime.value = 0;
    difficulty.value = '';
    category.value = '';
    ingredients.clear();
    directions.clear();
  }
}
