import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpad/app/controller/bookmark_controller.dart';
import 'package:foodpad/app/controller/edit_profile_controller.dart';
import 'package:foodpad/app/controller/menu_controller.dart';
import 'package:foodpad/app/modules/home/convect_navbar.dart';
import 'package:foodpad/app/modules/login_register/setup_screen.dart';
import 'package:foodpad/app/modules/login_register/welcome_page.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      // บันทึก UID ไว้ใน SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('uid', uid);

      Get.delete<MyRecipesController>(); // เผื่อ Controller ยังค้างจากรอบเก่า
      Get.delete<BookmarkController>(); // เช่น login หลายรอบ
      final myRecipesController = Get.put(MyRecipesController());
      final bookmarkController = Get.put(BookmarkController());
      final editProfileController = Get.put(EditProfileController());

      await editProfileController.fetchUser(uid);
      await myRecipesController.fetchMyRecipes();
      bookmarkController.listenToBookmarks();

      // ตรวจสอบว่าเคย setup โปรไฟล์หรือยัง
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data()!.containsKey("firstName")) {
        Get.offAll(() => MainNavScreen());
      } else {
        Get.to(() => SetupProfileScreen(uid: uid));
      }

      Get.snackbar("Success", "Login success");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Something went wrong");
    } catch (e) {
      Get.snackbar("Error", "Unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Sign out from Firebase Authentication
      await _auth.signOut();

      // 🔥 ลบ Controller เก่าทิ้ง
      Get.delete<MyRecipesController>();
      Get.delete<BookmarkController>();
      Get.delete<EditProfileController>();

      // Clear uid from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      // Navigate to WelcomePage
      Get.offAll(() => WelcomePage());
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    }
  }
}
