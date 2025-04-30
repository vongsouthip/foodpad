import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/add_menu_controller.dart';
import 'package:foodpad/app/modules/add_menu_page_view/dropdown.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildInfoPage() {
  final controller = Get.put(AddMenuController());
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Information",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.dmSans().fontFamily,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cooking Time: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 80,
              width: 220,
              decoration: BoxDecoration(
                color: CustomColors.fillColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.cookingTime.value > 0)
                        controller.cookingTime.value--;
                    },
                    icon: const Icon(Icons.remove_outlined),
                  ),
                  Text(
                    "${controller.cookingTime.value} min",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => controller.cookingTime.value++,
                    icon: const Icon(Icons.add_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Difficulty: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Container(
              height: 80,
              width: 220,
              decoration: BoxDecoration(
                color: CustomColors.fillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: dropDownDifficulty(),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Container(
              height: 80,
              width: 220,
              decoration: BoxDecoration(
                color: CustomColors.fillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: dropDownCategory(),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
