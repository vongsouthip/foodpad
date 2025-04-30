import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpad/app/modules/home/convect_navbar.dart';
import 'package:foodpad/app/modules/login_register/setup_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isSigningIn = false.obs;

  Future<void> signInWithGoogle() async {
    try {
      isSigningIn.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSigningIn.value = false;
        return; // user canceled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      isSigningIn.value = false;

      await checkUserProfile();
    } catch (e) {
      isSigningIn.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> checkUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 🛠 Save UID ลง SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      // ถ้ามีข้อมูล profile แล้ว → เข้าหน้า Home ได้เลย
      Get.offAll(() => MainNavScreen());
    } else {
      // ถ้ายังไม่มี profile → ต้องไป Setup Profile ก่อน
      Get.offAll(() => SetupProfileScreen(uid: user.uid));
    }
  }

  Future<void> signOutGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      // 1. เช็กว่าล็อกอินด้วย Google จริงหรือไม่
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut(); // ✅ ออกจากบัญชี Google
      }

      // 2. ออกจาก Firebase
      await FirebaseAuth.instance.signOut(); // ✅ เคลียร์ session ของ Firebase

      print("✅ Google Sign-Out success");
    } catch (e) {
      print("❌ Google Sign-Out error: $e");
    }
  }
}
