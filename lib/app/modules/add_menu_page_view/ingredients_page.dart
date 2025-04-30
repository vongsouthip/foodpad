import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/add_menu_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildIngredientsPage() {
  final controller = Get.put(AddMenuController());
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ingredients",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Obx(
            () => Column(
              children: List.generate(controller.ingredients.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Ingredient ${index + 1}',
                            filled: true,
                            fillColor: CustomColors.fillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                          initialValue: controller.ingredients[index],
                          onChanged: (val) => controller.ingredients[index] = val,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        onPressed: () => controller.ingredients.removeAt(index),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: controller.addIngredientField,
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
