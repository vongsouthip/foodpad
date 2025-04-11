import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var address = ''.obs;
  var profileImage = ''.obs;
  var backgroundImage = ''.obs;

  var isLoading = false.obs;

  // TextField
  final firstNameCtrl = Rx<TextEditingController>(TextEditingController());
  final lastNameCtrl = Rx<TextEditingController>(TextEditingController());
  final addressCtrl = Rx<TextEditingController>(TextEditingController());

  @override
  void onInit() {
    super.onInit();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      fetchUser(uid);
    }
  }

  Future<void> fetchUser(String uid) async {
    isLoading.value = true;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      firstName.value = data['firstName'] ?? '';
      lastName.value = data['lastName'] ?? '';
      address.value = data['address'] ?? '';
      profileImage.value = data['profileImage'] ?? '';
      backgroundImage.value = data['backgroundImage'] ?? '';

      //  TextField
      firstNameCtrl.value.text = firstName.value;
      lastNameCtrl.value.text = lastName.value;
      addressCtrl.value.text = address.value;

      // print(firstName);
      // print(lastName);
    }
    isLoading.value = false;
  }

  Future<void> updateUser(String uid) async {
    isLoading.value = true;

    firstName.value = firstNameCtrl.value.text;
    lastName.value = lastNameCtrl.value.text;
    address.value = addressCtrl.value.text;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'firstName': firstNameCtrl.value.text.trim(),
      'lastName': lastNameCtrl.value.text.trim(),
      'address': addressCtrl.value.text.trim(),
      'profileImage': profileImage.value,
      'backgroundImage': backgroundImage.value,
    });
    Get.snackbar("Success", "Profile updated successfully");
    isLoading.value = false;
  }

  Future<void> pickAndUploadImage({required bool isProfile}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final fileName = picked.name;

    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path, filename: fileName),
      'upload_preset': 'code camp',
    });

    final dioInstance = dio.Dio();
    final response = await dioInstance.post(
      'https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      final url = response.data['secure_url'];
      if (isProfile) {
        profileImage.value = url;
      } else {
        profileImage.value = url;
      }
    }
  }

  Future<void> pickAndUploadBackgroundImage({required bool isProfile}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    print('object');
    if (picked == null) return;

    final file = File(picked.path);
    final fileName = picked.name;

    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path, filename: fileName),
      'upload_preset': 'code camp',
    });

    final dioInstance = dio.Dio();
    final response = await dioInstance.post(
      'https://api.cloudinary.com/v1_1/ddlf8tlyp/image/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      final url = response.data['secure_url'];
      if (isProfile) {
        backgroundImage.value = url;
      } else {
        backgroundImage.value = url;
      }
    }
  }
}
