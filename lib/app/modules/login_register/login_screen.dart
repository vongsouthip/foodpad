import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/google_sign_in_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/login_register/login_email_screen.dart';
import 'package:foodpad/app/modules/login_register/register_email.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/welcome2.png',
                      ), // Add your image in assets
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur elit, sed do eiusmod tempor incididunt.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.mainColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Get.to(
                            RegisterScreen(),
                            transition: Transition.rightToLeftWithFade,
                          );
                        },
                        icon: const Icon(Icons.email),
                        label: const Text("Register using email"),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            "OR",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Container(
                            width: 40,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            if (googleSignInController.isSigningIn.value) {
                              return const CircularProgressIndicator();
                            } else {
                              return IconButton(
                                onPressed: () {
                                  googleSignInController.signInWithGoogle();
                                },
                                icon: Image.asset(
                                  'assets/images/google.png',
                                  width: 40,
                                  height: 40,
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.to(LoginEmailScreen());
                          },
                          child: const Text(
                            "Have an account? Login",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            width: 80,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 50.w,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.fillColor,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: CustomColors.mainColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
