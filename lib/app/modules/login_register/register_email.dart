import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/register_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/login_register/login_email_screen.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Get.to(LoginEmailScreen(), transition: Transition.rightToLeft);
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
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
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  //register with email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your email";
                      }
                      if (!value.contains("@")) {
                        return "please enter a valid email";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: CustomColors.fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your password";
                      }
                      if (value.length < 6) {
                        return "password must be at least 6 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: CustomColors.fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: CustomColors.fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your password";
                      }
                      if (value.length < 6) {
                        return "password must be at least 6 characters";
                      }
                      if (value != passwordController.text) {
                        return "passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "By creating an account, you agree to our",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              "Terms & Conditions",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (_formKey1.currentState!.validate()) {
                    registerController.register(
                      email: emailController.text,
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.mainColor,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    registerController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
