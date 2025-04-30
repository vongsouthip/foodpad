import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/add_menu_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';

Widget buildTitlePage() {
  final controller = Get.put(AddMenuController());
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Title",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter Menu name...',
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
          style: const TextStyle(fontSize: 16),
          onChanged: (val) => controller.recipeTitle.value = val,
        ),
        const SizedBox(height: 16),
        const Text(
          "Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,

            children: [
              ...controller.recipeImages.map(
                (file) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
