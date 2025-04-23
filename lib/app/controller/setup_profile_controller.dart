import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:foodpad/app/modules/home/convect_navbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SetupProfileController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var address = ''.obs;
  var imageFile = Rx<File?>(null);
  var imageUrl = ''.obs;
  var isLoading = false.obs;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Get.snackbar("Error", "❌ No image selected.");
      return;
    }

    imageFile.value = File(pickedFile.path);
    await uploadImage(imageFile.value!);
  }

  Future<void> uploadImage(File file) async {
    final fileName = file.path.split('/').last;
    final dioInstance = dio.Dio();

    final formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "upload_preset": "code camp",
    });

    try {
      final response = await dioInstance.post(
        "https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload",
        data: formData,
      );

      if (response.statusCode == 200) {
        imageUrl.value = response.data['secure_url'];
        Get.snackbar("Success", "✅ Upload success!");
      } else {
        Get.snackbar("Error", "❌ Upload failed: ${response.statusMessage}");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Upload error: $e");
    }
  }

  Future<void> saveProfile(String uid) async {
    if (firstName.value.isEmpty || lastName.value.isEmpty || address.value.isEmpty) {
      Get.snackbar("Error", "❌ Please fill in all fields.");
      return;
    }

    if (imageUrl.isEmpty) {
      Get.snackbar("Error", "❌ Please upload a profile picture.");
      return;
    }

    isLoading.value = true;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "firstName": firstName.value,
      "lastName": lastName.value,
      "address": address.value,
      "profileImage": imageUrl.value,
      "createdAt": FieldValue.serverTimestamp(),
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);

    isLoading.value = false;
    Get.offAll(() => MainNavScreen());
  }
}
