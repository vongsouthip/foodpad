import 'package:flutter/material.dart';
import 'package:foodpad/app/modules/login_register/welcome_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
