import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    
    if (uid != null) {
      // ถ้าล็อกอินแล้ว ให้เปลี่ยน route ไปยังหน้าหลัก
      Navigator.pushReplacementNamed(context, '/main_nav_screen');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }
}
