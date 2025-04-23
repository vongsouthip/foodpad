import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpad/app/modules/home/convect_navbar.dart';
import 'package:foodpad/app/modules/login_register/setup_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match.");
      return;
    }
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      String uid = userCredential.user!.uid;
      
      // บันทึกข้อมูลผู้ใช้เบื้องต้นใน Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "email": email.trim(),
        "created_at": FieldValue.serverTimestamp(),
      });
      
      // เช็คสถานะการตั้งค่าโปรไฟล์
      await _checkUserProfile(uid);
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Error occurred");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred");
    }
    isLoading.value = false;
  }

  Future<void> _checkUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (doc.exists && doc.data()!.containsKey("firstName")) {
      // ถ้าโปรไฟล์ถูกตั้งค่าแล้ว
      prefs.setString('uid', uid);
      Get.offAll(() => MainNavScreen());
    } else {
      // ยังไม่ได้ตั้งค่าโปรไฟล์
      Get.to(() => SetupProfileScreen(uid: uid));
    }
  }
}
