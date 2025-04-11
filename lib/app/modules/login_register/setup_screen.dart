import 'package:flutter/material.dart';
import 'package:foodpad/app/controller/setup_profile_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SetupProfileScreen extends StatelessWidget {
  final String uid;
  SetupProfileScreen({Key? key, required this.uid}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final SetupProfileController setupProfileController = Get.put(
    SetupProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Account Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C2F4A), // Approx text color
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: setupProfileController.pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        setupProfileController.imageFile.value != null
                            ? FileImage(setupProfileController.imageFile.value!)
                            : null,
                    child:
                        setupProfileController.imageFile.value == null
                            ? const Icon(Icons.camera_alt)
                            : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged:
                      (value) => setupProfileController.firstName.value = value,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    filled: true,
                    fillColor: const Color(0xFFE6F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged:
                      (value) => setupProfileController.lastName.value = value,
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    filled: true,
                    fillColor: const Color(0xFFE6F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  onChanged:
                      (value) => setupProfileController.address.value = value,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    filled: true,
                    fillColor: const Color(0xFFE6F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setupProfileController.saveProfile(uid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child:
                        setupProfileController.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
