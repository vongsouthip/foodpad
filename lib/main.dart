import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/modules/home/convect_navbar.dart';
import 'package:foodpad/app/modules/home/edit_profile_screen.dart';
import 'package:foodpad/app/modules/home/home.dart';
import 'package:foodpad/app/modules/home/menu_detail.dart';
import 'package:foodpad/app/modules/home/profile_screen.dart';
import 'package:foodpad/app/modules/login_register/login_screen.dart';
import 'package:foodpad/app/modules/login_register/welcome_page.dart';
import 'package:foodpad/splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        1344,
        2992,
      ), // ขนาดต้นแบบ UI ที่คุณออกแบบ (ปกติใช้ 360x690 หรือแล้วแต่)
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: GoogleFonts.dmSans().fontFamily),
            home: SplashView(),
            routes: {
              '/splash': (context) => SplashView(),
              '/login': (context) => LoginScreen(),
              '/welcome': (context) => WelcomePage(),
              '/editProfile': (context) => EditProfilePage(),
              '/home': (context) => HomePage(),
              '/navbar': (context) => MainNavScreen(),
              '/menu_detail': (context) => MenuDetail(),
              '/main_nav_screen': (context) => MainNavScreen(),
              '/profile': (context) => ProfileScreen(),
            },
          ),
    );
  }
}
