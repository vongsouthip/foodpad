import 'package:flutter/material.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/login_register/register_email.dart';
import 'package:foodpad/app/modules/login_register/welcome_page.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.facebook,
                            ), // Add Google icon in assets
                            iconSize: 40,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.apple),
                            iconSize: 40,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: TextButton(
                          onPressed: () {},
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
                width: 50,
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
